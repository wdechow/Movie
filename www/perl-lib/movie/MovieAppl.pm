package MovieAppl;

use strict;
use warnings;

use LibMovie;
use JSON;
use POSIX;


# This flag spacifies if debug messages should be printed
# 0 = no debug messages will be printet, 0 > debug messages will be printed
$main::DEBUG = 0;

# Sets the number of movies per page for the paging calculation
# This variable has to be set to the same value as NUMBER_OF_MOVIES in movie.js
$main::NUMBER_OF_MOVIES = 20;




# ==============
# This method handles a request
#
# @param $main::dbh Database handler
# @param $main::p Reference to the parameter hash
#
# @return 500 on Error, 1 else
#
sub handle_request
{
  # the global database handler
  $main::dbh  = shift;

  # the global reference to the parameter hash
  $main::p    = shift;


  unless( $$main::p{ 'method' } && ( $$main::p{ 'method' } ne "" ) )
  {
    LibMovie::mk_error( "No method given!" );
    return 500;
  }

  if( $$main::p{ 'method' } eq "get_table_data" )
  {
    unless( get_table_data( ) )
    {
      return 500;
    }
  }
  else
  {
    LibMovie::mk_error( "Unknown method given: " . $$main::p{ 'method' } );
    return 500;
  }

  return 1;
}


# ==============
# selects all information to show in the movie table
#
# $$main::p{ 'from' } is the first entry to select. The given parameter starts at 1 while the database starts at 0.
# $$main::p{ 'count' } number of entries to select.
#
sub get_table_data
{
  unless( valid_get_table_data_parameters( ) )
  {
    return;
  }

  my $sql = "select MOV_ID, MOV_TITLE, MOV_SUBTITLE, MOV_TITLE_ORIGINAL, MOV_SUBTITLE_ORIGINAL, MOV_FSK, MOV_RUNTIME_MINUTE, MOV_RELEASE_DATE from TBL_MOVIE limit ?, ?;";
  my $sqlh;
  my @row;

  # This array containes the data returned to the client, as json
  my @data;
  # This hash contains all paging information
  my %paging;


  # -1 because given parameter starts at 1 and in mysql it starts at 0
  unless( $sqlh = LibMovie::execute_sql( $main::dbh, $sql, $$main::p{ 'from' } - 1, $$main::p{ 'count' } ) )
  {
    return;
  }


  # If i can't get the paging information i have to abort
  unless( get_paging( \%paging ) )
  {
    return;
  }

  push( \@data, \%paging );


  # creating entry objects for the json
  while( @row = $sqlh -> fetchrow_array( ) )
  {
    my %entry;
    $entry{ 'id' }                = $row[ 0 ];
    $entry{ 'title' }             = $row[ 1 ];
    $entry{ 'subtitle' }          = $row[ 2 ];
    $entry{ 'title_original' }    = $row[ 3 ];
    $entry{ 'subtitle_original' } = $row[ 4 ];
    $entry{ 'fsk' }               = $row[ 5 ];
    $entry{ 'runtime' }           = $row[ 6 ];
    $entry{ 'release_date' }      = $row[ 7 ];

    push( \@data, \%entry );
  }

  $sqlh -> finish( );

  print encode_json( \@data );

  return 1;
}


# ==============
# validates the parameter for the method get_table_data
#
# @return 1 if all needed parameters are valid, 0 else
#
sub valid_get_table_data_parameters
{
  my $valid_flag = 1;

  # checking from
  if( ! defined( $$main::p{ 'from' } ) )
  {
    LibMovie::mk_error( "get_table_data: 'from' not given!" );
    $valid_flag = 0;
  }
  elsif( $$main::p{ 'from' } < 1 )
  {
    LibMovie::mk_error( "get_table_data: 'from' has to be >= 1!" );
    $valid_flag = 0;
  }


  # checking count
  if( ! defined( $$main::p{ 'count' } ) )
  {
    LibMovie::mk_error( "get_table_data: 'count' not given!" );
    $valid_flag = 0;
  }
  elsif( $$main::p{ 'count' } < 1 )
  {
    LibMovie::mk_error( "get_table_data: 'count' has to be >= 1!" );
    $valid_flag = 0;
  }

  return $valid_flag;
}


# ==============
# creates the paging hash
#
# @param paging_ref Reference to the paging hash
#
sub get_paging
{
  my $paging_ref = shift;

  my $sql = "select count(*) from TBL_MOVIE;";
  my $sqlh;
  my @row;

  unless( $sqlh = LibMovie::execute_sql( $main::dbh, $sql ) )
  {
    return;
  }

  if( @row = $sqlh -> fetchrow_array( ) )
  {
    $$paging_ref{ 'pages' } = ceil( $row[ 0 ] / $main::NUMBER_OF_MOVIES );
  }
  else
  {
    $sqlh -> finish( );
    return;
  }

  $sqlh -> finish( );


  return 1;
}



1;