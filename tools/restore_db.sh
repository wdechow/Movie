number_of_tables=11
password="P4l.xA#3W?s_"

if [ $# -lt 1 ]
then
  echo "Backup directory needed!"
  echo "Aborting."
  exit
fi

if [ ! -d $1 ]
then
  echo "Given parameter is no valid directory!"
  echo "Aborting."
  exit
fi

pushd $1

number_of_files=$(ls *.sql.gz | wc -l)

if [ "$number_of_files" != "$number_of_tables" ]
then
  echo "[WARNING] Number of backup files does not match number of tables."
  echo "[WARNING] This restore script dropts the entire database, creates it new and inserts only the dumped tables."
  echo "Do you want to continue?"

  read answer

  if [ "$answer" != "yes" -o "$answer" != "y" -o "$answer" != "ja" -o "$answer" != "j" ]
  then
    echo "Aborting."
    exit
  fi
fi

echo "Dropping MovieDB_1_0 ..."
mysql -u movie --password=$password -e "drop database if exists MovieDB_1_0;"

echo "Creating MovieDB_1_0 ..."
mysql -u movie --password=$password < /home/wolfgang/Projekte/Movie/database/create_movie_db.sql

echo "Inserting data ..."
for file in *.sql.gz
do
  gunzip < dump_TBL_MOVIE.sql.gz | mysql -u movie --password=$password --database=MovieDB_1_0
done


popd