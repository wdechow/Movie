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
  my $c = $r -> connection;

  $r -> content_type( 'text/html; charset=UTF-8' );

  my $db_handler;
  my %params;

  unless( $db_handler = LibMovie::db_connect( ) )
  {
    LibMovie::mk_error( "Could not connect to database!" );
    return;
  }

  LibMovie::get_request_parameter( \%params );

  MovieAppl::handle_request( $db_handler, \%params );

  LibMovie::db_close( $db_handler );

  return;
}

1;
