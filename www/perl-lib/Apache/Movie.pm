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
  warn "=============================================================\n";
  warn "                   Movie: Handling Call\n";
  warn "=============================================================\n";

  my $r = shift;
  my $c = $r -> connection;

  $r -> content_type( 'text/html; charset=UTF-8' );

  MovieAppl::run_movie( );

  return;
}

1;
