package LibMovie;

use strict;
use warnings;

use DBI;
use DBD::mysql;





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
    warn "Can't prepare statement: $sql\n";
    return;
  }

  unless( $sqlh -> execute( @_ ) )
  {
    warn "Can't execute statement: $sql, " . join( ", ", @_ ) . "\n";
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
    warn "Can't close DB connection without database handler!\n";
    return;
  }

  $db_handler -> disconnect( );
}


1;