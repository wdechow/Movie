package LibMovie;

use strict;
use warnings;

use DBI;
use DBD::mysql;





# ==============
# prepares and executes the given sql statement
#
# @param $local_dbh database handler
# @param $sql SQL statement to execute
# @param *varargs* variables for the sql statement (these replace the ? in $sql)
#
# @return statement handler if everything was ok, undefined else
#
sub execute_sql
{
  my $local_dbh = shift;
  my $sql       = shift;

  my $sqlh;

  unless( $sqlh = $local_dbh -> prepare( $sql ) )
  {
    print "Can't prepare statement: $sql\n";
    return;
  }

  unless( $sqlh -> execute( @_ ) )
  {
    print "Can't execute statement: $sql, " . join( ", ", @_ ) . "\n";
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
  my $c = "DBI:mysql:database=MovieDB_1_0;host=127.0.0.1";
  my $u = "movie";
  # a secure password is pretty useless if stored in public :D
  # well useless information does not need protection
  my $p = "P4l.xA#3W?s_";
  my $d;

  unless( $d = DBI -> connect( $c, $u, $p ) )
  {
      return;
  }

  $d -> do( "set autocommit = 1" );

  return $d;
}


# ==============
# closes the database connection
#
# @param $d database handler
#
sub db_close
{
  my $d = shift;
  $d -> disconnect( );
}


1;