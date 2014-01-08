number_of_tables=11
path=$(pwd)

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


pushd $1 >/dev/null

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
mysql -e "drop database if exists MovieDB_1_0;"


pushd $path >/dev/null

echo "Creating MovieDB_1_0 ..."
mysql < ../database/create_movie_db.sql

popd >/dev/null

echo "Inserting data ..."
for file in *.sql.gz
do
  # here the database name is important because it can't be
  # specified in the .my.cnf due to the use when dropping and creating it
  gunzip < $file | mysql -D MovieDB_1_0
done


popd >/dev/null