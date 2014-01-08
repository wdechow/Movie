package LibMovie;

use strict;
use warnings;

use CGI;
use DBI;
use DBD::mysql;





# ==============
# gets all parameter from the request and saves them
# in the parameter hash reference
#
# @param reference to parameter hash
#
sub get_request_parameter
{
  my $ref_params  = shift;

  my $cgi = CGI -> new;
  my $params = $cgi -> Vars;

  foreach my $key( keys( %$params ) )
  {
    mk_log( "Getting param: $key = $$params{ $key }" );
    $$ref_params{ $key } = $$params{ $key };
  }
}


# ==============
# creates a formatted timestamp for log messages
#
# @return formatted timestamp
#
sub get_logging_timestamp
{
  my ( $second, $minute, $hour, $day, $month, $year ) = localtime;
  my $timestamp = sprintf( "%02d-%02d-%04d %02d:%02d:%02d", $day, $month + 1, $year + 1900, $hour, $minute, $second );

  return $timestamp;
}


# ==============
# handles proper log output
#
# @param log message to handle
#
sub mk_log
{
  my $msg = shift;
  my $timestamp = get_logging_timestamp( );

  warn "[ Movie LOG ] [ $timestamp ]: $msg\n";
}


# ==============
# handles proper error output
#
# @param error message to handle
#
sub mk_error
{
  my $msg = shift;
  my $timestamp = get_logging_timestamp( );

  warn "[ Movie ERROR ] [ $timestamp ]: $msg\n";
}


# ==============
# handles proper info output
#
# @param info message to handle
#
sub mk_info
{
  my $msg = shift;
  my $timestamp = get_logging_timestamp( );

  warn "[ Movie INFO ] [ $timestamp ]: $msg\n";
}


# ==============
# prepares and executes the given sql statement
#
# @param $db_handler database handler
# @param $sql SQL statement to execute
# @param *varargs* variables for the sql statement (these replace the ? in $sql)
#
# @return statement handler if everything was ok, undefined else
#
sub execute_sql
{
  my $db_handler  = shift;
  my $sql         = shift;

  my $sqlh;

  unless( $sqlh = $db_handler -> prepare( $sql ) )
  {
    mk_error( "Can't prepare statement: $sql" );
    return;
  }

  unless( $sqlh -> execute( @_ ) )
  {
    mk_error( "Can't execute statement: $sql, " . join( ", ", @_ ) );
    return;
  }

  return $sqlh;
}


# ==============
# establishes the database connection
#
# @return database handler
#
sub db_connect
{
  my $db_connection_string  = "DBI:mysql:database=MovieDB_1_0;host=127.0.0.1";
  my $user                  = "movie";
  # a secure password is pretty useless if stored in public :D
  # well useless information does not need protection
  my $password              = "P4l.xA#3W?s_";
  my $db_handler;

  unless( $db_handler = DBI -> connect( $db_connection_string, $user, $password ) )
  {
    return;
  }

  $db_handler -> do( "set autocommit = 1" );

  return $db_handler;
}


# ==============
# closes the database connection
#
# @param $db_handler database handler
#
sub db_close
{
  my $db_handler;

  unless( $db_handler = shift )
  {
    mk_error( "Can't close DB connection without database handler!" );
    return;
  }

  $db_handler -> disconnect( );
}


1;