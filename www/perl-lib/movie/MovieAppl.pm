package MovieAppl;

use strict;
use warnings;

use LibMovie;
use JSON;

sub handle_request
{
  # the global database handler
  $main::dbh  = shift;

  # the global reference to the parameter hash
  $main::p    = shift;


  unless( $$main::p{ 'method' } && ( $$main::p{ 'method' } ne "" ) )
  {
    LibMovie::mk_error( "No method given!" );
    return;
  }

  if( $$main::p{ 'method' } eq "get_table_data" )
  {
    print get_table_data( );
  }
}


sub get_table_data
{
  my @test_data;

  my %test_paging;
  my %test_ogj_1;
  my %test_ogj_2;
  my %test_ogj_3;

  $test_paging{ 'a' }           = 1;
  $test_paging{ 'b' }           = 2;
  $test_paging{ 'c' }           = 3;

  $test_ogj_1{ 'id' }           = 1;
  $test_ogj_1{ 'title' }        = "Reservour Dogs";
  $test_ogj_1{ 'subtitle' }     = "";
  $test_ogj_1{ 'runtime' }      = 110;
  $test_ogj_1{ 'release_date' } = "16.12.1985";

  $test_ogj_2{ 'id' }           = 2;
  $test_ogj_2{ 'title' }        = "Dark Knight";
  $test_ogj_2{ 'subtitle' }     = "";
  $test_ogj_2{ 'runtime' }      = 100;
  $test_ogj_2{ 'release_date' } = "17.12.1985";

  $test_ogj_3{ 'id' }           = 3;
  $test_ogj_3{ 'title' }        = "Snatch";
  $test_ogj_3{ 'subtitle' }     = "Schweine und Diamanten";
  $test_ogj_3{ 'runtime' }      = 200;
  $test_ogj_3{ 'release_date' } = "15.12.1985";


  push( @test_data, \%test_paging );
  push( @test_data, \%test_ogj_1 );
  push( @test_data, \%test_ogj_2 );
  push( @test_data, \%test_ogj_3 );

  return encode_json( \@test_data );
}

1;
