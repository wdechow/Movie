##########
# This script starts the VLC-Player
#
# @param $1 Path to (and including) the VIDEO_TS directory
# @param $2 Audio Language (short, de, en, ...)
# @param $3 Subtitle Language (short, de, en, ...)
#


if [ ! -d $1 ]
then
  exit 8
fi



vlc -vvv --play-and-exit --playlist-autostart --audio-language $2 --no-sub-autodetect-file --no-dvdnav-menu --quiet --fullscreen --no-osd "dvdsimple://$1"  1>/srv/www/bin/movie/log.txt 2>&1 &
