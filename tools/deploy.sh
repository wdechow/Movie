user=$(whoami)

if [ "$user" != "root" ]
then
  echo "This script has to be run as root!"
  exit 1
fi

pushd /home/wolfgang/Projekte/Movie/tools/ >/dev/null

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
  if [ -d $1 ]
  then
    path=$(dirname "$0")
    $path/restore_db.sh $1
  fi
fi

popd >/dev/null