package Apache::Movie;

use strict;
use warnings;

BEGIN
{
  push( @INC, "/srv/www/perl-lib/movie/" );
}


use Apache2::RequestRec( );
use Apache2::RequestUtil( );

# The Movie application script
# Handles all Requests
use MovieAppl;

# The Movie library
# Contains essential methods
use LibMovie;

sub handler
{
  LibMovie::mk_log( "============================================================" );
  LibMovie::mk_log( "                    Movie: Handling Call                    " );
  LibMovie::mk_log( "============================================================" );


  my $r = shift;
  $r -> content_type( 'text/html; charset=UTF-8' );


  # This parameter sets the response status
  my $response_status;

  # database handler
  my $db_handler;

  # parameter hash
  my %params;


  # open the database handler
  unless( $db_handler = LibMovie::db_connect( ) )
  {
    LibMovie::mk_error( "Could not connect to database!" );
    $r -> status( 500 );
    return;
  }


  # retreive the given request parameter
  LibMovie::get_request_parameter( \%params );


  # if handle_request returns a response status, the response status will be set
  $response_status = MovieAppl::handle_request( $db_handler, \%params );

  if( $response_status != 1 )
  {
    LibMovie::mk_log( "Response status: $response_status" );
    $r -> status( $response_status );
  }


  # close the database handler
  LibMovie::db_close( $db_handler );

  return;
}


1;