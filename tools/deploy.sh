user=$(whoami)

if [ "$user" != "root" ]
then
  echo "This script has to be run as root!"
  exit 1
fi

# current directory of caller
current_dir=$(pwd)

# directory given in the call
call_path=$(dirname "$0")

# absolute path to the tools directory containing this script
tools_path=$current_dir/$call_path


pushd $tools_path >/dev/null

echo "replacing movie files in htdocs ..."
rm -r /srv/www/htdocs/movie
cp -r ../www/htdocs/movie /srv/www/htdocs/
cp ../www/htdocs/movie.html /srv/www/htdocs/

echo "replacing movie files in perl-lib ..."
rm -r /srv/www/perl-lib/movie
cp -r ../www/perl-lib/movie /srv/www/perl-lib/
cp ../www/perl-lib/Apache/Movie.pm /srv/www/perl-lib/Apache/

echo "replacing httpd.conf ..."
cp ../config_files/httpd.conf /etc/apache2/

echo "replacing mod_perl.conf ..."
cp ../config_files/mod_perl.conf /etc/apache2/conf.d/

echo "replacing .my.cnf ..."
cp ../config_files/.my.cnf ~/.my.cnf

echo "restarting apache ..."
rcapache2 restart


# If a parameter is given, i have to check if its a valid backup directory
if [ ! -z $1 ]
then
  # if an absolute backup directory path is given i can call restore_db.sh
  if [ -d $1 ]
  then
    ./restore_db.sh $1
  else
    # If the backup directory can not be found with absolute path
    # i will try the relative path to
    if [ -d $current_dir/$1 ]
    then
      ./restore_db.sh $current_dir/$1
    else
      echo "given backup directory does not exist ... ignoring restore!"
      echo "tried: $1"
      echo "tried: $current_dir/$1"
    fi
  fi
fi

popd >/dev/null