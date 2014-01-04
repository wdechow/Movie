all_tables=( "TBL_MOVIE" "TBL_ACTOR" "TBL_MOVIE_ACTOR" "TBL_LANGUAGE" "TBL_MOVIE_LANGUAGE" "TBL_MOVIE_SUBTITLE" "TBL_SONG" "TBL_MOVIE_SONG" "TBL_WATCH" "TBL_GENRE" "TBL_MOVIE_GENRE" )
dir_name=$(date +"%d_%m_%Y_T_%H_%M_%S")

pushd /home/wolfgang/Projekte/Movie/database/backup


# delete oldest backups, so that there is a maximum of 9 old backups left
echo "deleting old backups ..."
ls -t | sed -e '1,9d' | xargs -d '\n' rm -r

# create current backup directory, this is the 10th backup
mkdir $dir_name

# dumping tables
# $# = Number of call parameter
if [ $# -gt 0 ]
then
  for table in "$@"
  do
    echo "dumping specific table: $table"
    mysqldump -u movie --password=P4l.xA#3W?s_ --no-create-db --no-create-info --compact --complete-insert --quick --disable-keys MovieDB_1_0 $table | gzip > $dir_name/dump_$table.sql.gz
  done
else
  echo "dumping all tables:"
  for table in "${all_tables[@]}"
  do
    echo "  $table"
    mysqldump -u movie --password=P4l.xA#3W?s_ --no-create-db --no-create-info --compact --complete-insert --quick --disable-keys MovieDB_1_0 $table | gzip > $dir_name/dump_$table.sql.gz
  done
fi

popd