package Apache::Movie;

use strict;
use warnings;

use Apache2::RequestRec( );
use Apache2::RequestUtil( );

# use Movie;

sub handler
{
  warn "=============================================================\n";
  warn "                   Movie: Handling Call\n";
  warn "=============================================================\n";

  my $r = shift;
  my $c = $r -> connection;

  $r -> content_type( 'text/html; charset=UTF-8' );

  # run_movie( );

  return;
}

1;
