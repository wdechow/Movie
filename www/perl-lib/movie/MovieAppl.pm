package MovieAppl;

use strict;
use warnings;

use LibMovie;
use JSON;
use POSIX;


# This flag spacifies if debug messages should be printed
# 0 = no debug messages will be printet, 0 > debug messages will be printed
$main::DEBUG = 1;

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
  elsif( $$main::p{ 'method' } eq "get_movie_detail" )
  {
    unless( get_movie_detail( ) )
    {
      return 500;
    }
  }
  elsif( $$main::p{ 'method' } eq "start_vlc" )
  {
    unless( start_vlc( ) )
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

  my $sql = "";
  $sql .= "select MOV_ID, MOV_TITLE, MOV_SUBTITLE, MOV_TITLE_ORIGINAL, MOV_SUBTITLE_ORIGINAL, MOV_FSK, MOV_RUNTIME_MINUTE, date_format(MOV_RELEASE_DATE, '%d-%m-%Y') ";
  $sql .= "from TBL_MOVIE ";
  $sql .= "order by MOV_TITLE asc ";
  $sql .= "limit ?, ?;";

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


  # selecting the number of movies from the database
  unless( $sqlh = LibMovie::execute_sql( $main::dbh, $sql ) )
  {
    return;
  }

  if( @row = $sqlh -> fetchrow_array( ) )
  {
    # The number of pages = number of movies in DB / number of movies displayed on one page
    $$paging_ref{ 'pages' } = ceil( $row[ 0 ] / $main::NUMBER_OF_MOVIES );
  }
  else
  {
    LibMovie::mk_error( "Could not receive paging information!" );
    $sqlh -> finish( );
    return;
  }

  $sqlh -> finish( );


  return 1;
}


# ==============
# selects the movie detail information from the database
#
# $$main::p{ 'id' } Movie ID
#
sub get_movie_detail
{
  my $cover;
  my @actors;
  my @languages;
  my @subtitles;

  unless( get_cover( \$cover ) )
  {
    return;
  }

  unless( get_actors( \@actors ) )
  {
    return;
  }

  unless( get_languages( \@languages ) )
  {
    return;
  }

  unless( get_subtitles( \@subtitles ) )
  {
    return;
  }

  my %data;
  $data{ 'cover' }      = $cover;
  $data{ 'actors' }     = \@actors;
  $data{ 'languages' }  = \@languages;
  $data{ 'subtitles' }  = \@subtitles;

  print encode_json( \%data );

  return 1;
}


# ==============
# selects the cover for the movie
#
# @param $cover_ref Reference to the cover scalar
#
# $$main::p{ 'id' } Movie ID
#
sub get_cover
{
  my $cover_ref = shift;

  my $sql = "select MOV_COVER from TBL_MOVIE where MOV_ID = ?;";
  my $sqlh;
  my @row;

  unless( $sqlh = LibMovie::execute_sql( $main::dbh, $sql, $$main::p{ 'id' } ) )
  {
    return;
  }

  if( @row = $sqlh -> fetchrow_array( ) )
  {
    $$cover_ref = $row[ 0 ];
  }
  else
  {
    $sqlh -> finish( );
    return;
  }

  $sqlh -> finish( );

  return 1;
}


# ==============
# selects the actors for the movie
#
# @param actors_ref Reference to the actors array
#
# $$main::p{ 'id' } Movie ID
#
sub get_actors
{
  my $actors_ref = shift;

  my $sql = "select a.ACT_ALIAS from TBL_ACTOR a inner join TBL_MOVIE_ACTOR ma on a.ACT_ID = ma.MOA_ACT_ID where ma.MOA_MOV_ID = ?;";
  my $sqlh;
  my @row;

  unless( $sqlh = LibMovie::execute_sql( $main::dbh, $sql, $$main::p{ 'id' } ) )
  {
    return;
  }

  while( @row = $sqlh -> fetchrow_array( ) )
  {
    push( @$actors_ref, $row[ 0 ] );
  }

  $sqlh -> finish( );

  return 1;
}


# ==============
# selects the languages for the movie
#
# @param languages_ref Reference to the language array
#
# $$main::p{ 'id' } Movie ID
#
sub get_languages
{
  my $languages_ref = shift;

  my $sql = "select l.LAN_ID, l.LAN_SHORT, l.LAN_NAME from TBL_LANGUAGE l inner join TBL_MOVIE_LANGUAGE ml on l.LAN_ID = ml.MOL_LAN_ID where ml.MOL_MOV_ID = ?;";
  my $sqlh;
  my @row;

  unless( $sqlh = LibMovie::execute_sql( $main::dbh, $sql, $$main::p{ 'id' } ) )
  {
    return;
  }

  while( @row = $sqlh -> fetchrow_array( ) )
  {
    my %language;
    $language{ 'id' }     = $row[ 0 ];
    $language{ 'value' }  = $row[ 1 ];
    $language{ 'text' }   = $row[ 2 ];

    push( @$languages_ref, \%language );
  }

  $sqlh -> finish( );

  return 1;
}


# ==============
# selects the subtitles for the movie
#
# @param languages_ref Reference to the subtitles array
#
# $$main::p{ 'id' } Movie ID
#
sub get_subtitles
{
  my $languages_ref = shift;

  my $sql = "select l.LAN_ID, l.LAN_SHORT, l.LAN_NAME from TBL_LANGUAGE l inner join TBL_MOVIE_SUBTITLE ms on l.LAN_ID = ms.MOS_LAN_ID where ms.MOS_MOV_ID = ?;";
  my $sqlh;
  my @row;

  unless( $sqlh = LibMovie::execute_sql( $main::dbh, $sql, $$main::p{ 'id' } ) )
  {
    return;
  }

  # Subtitles are optional so the first entry is a none selected entry
  my %none_selected;
  $none_selected{ 'id' }    = 0;
  $none_selected{ 'value' } = "k";
  $none_selected{ 'text' }  = "Keine Untertitel";

  push( @$languages_ref, \%none_selected );


  # adding all found subtitles
  while( @row = $sqlh -> fetchrow_array( ) )
  {
    my %language;
    $language{ 'id' }     = $row[ 0 ];
    $language{ 'value' }  = $row[ 1 ];
    $language{ 'text' }   = $row[ 2 ];

    push( @$languages_ref, \%language );
  }

  $sqlh -> finish( );

  return 1;
}


# ==============
# starts the VLC-Player start script
#
# $$main::p{ 'id' } Movie ID
# $$main::p{ 'language' } Short name of the language for audio
# $$main::p{ 'subtitle' } undefined for no subtitles, or short version of subtitle language
#
sub start_vlc
{
  # Paths from the system command start at /

  my $path;
  my $language = $$main::p{ 'language' };
  my $subtitle = $$main::p{ 'subtitle' };
  my $retval;

  unless( $path = get_movie_path( $$main::p{ 'id' } ) )
  {
    LibMovie::mk_error( "Could not get Path for movie ID: " . $$main::p{ 'id' } );
    return;
  }

  if( defined( $subtitle ) )
  {
    LibMovie::mk_debug( $main::DEBUG, "Executing command: system( /srv/www/bin/movie/start_vlc.sh $path $language $subtitle )" );
    $retval = LibMovie::execute_command( "/srv/www/bin/movie/start_vlc.sh", $path, $language, $subtitle );
  }
  else
  {
    LibMovie::mk_debug( $main::DEBUG, "Executing command: system( /srv/www/bin/movie/start_vlc.sh $path $language )" );
    $retval = LibMovie::execute_command( "/srv/www/bin/movie/start_vlc.sh", $path, $language );
  }


  if( "$retval" ne "0" )
  {
    LibMovie::mk_error( "Could not start VLC-Player. Return value: $retval" );
    return;
  }

  return 1;
}


# ==============
# Selects MOV_PATH for the given MOV_ID from the database and returns it
#
# @param movie_id MOV_ID of the movie the path is requestd
#
# @return MOV_PATH for the given MOV_ID, or undefined if none is found
#
sub get_movie_path
{
  my $movie_id = shift;
  my $sql = "select MOV_PATH from TBL_MOVIE where MOV_ID = ?;";
  my $sqlh;
  my @row;

  my $path;

  unless( $sqlh = LibMovie::execute_sql( $main::dbh, $sql, $movie_id ) )
  {
    return;
  }

  if( @row = $sqlh -> fetchrow_array( ) )
  {
    $path = $row[ 0 ];
  }
  else
  {
    return;
  }

  $sqlh -> finish( );

  return $path;
}



1;