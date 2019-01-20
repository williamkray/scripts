#!/usr/bin/env bash 

## new script because the ruby thing i wrote a long time ago
## is just a mess and overly complicated, and doesn't work
## with my new configuration of containers where paths
## don't match up everywhere. so here we are.

set -e
USAGE='usage: ./rt-addshow.sh "My_TV_Show_Without_Weird_Symbols" "https://some-url.com/cool"'

if [[ -z $1 ]]; then
  echo "you're doing it wrong"
  echo $USAGE
  exit 1
fi

## capture arguments, this isn't written well enough to
## be resilient right now because i don't care
SHOWNAME="$1"
SHOWURL="$2"

## set these variables to however you've got things set up
#WATCHDIR_PATH_FOR_MKDIR='/mnt/rtorrent-docker/rtorrent-home/watch/'
WATCHDIR_PATH_FOR_MKDIR='/home/william/rt-testing/watch/'
WATCHDIR_PATH_FOR_RTORRENT='~/watch/'
#DESTDIR_PATH_FOR_MKDIR='/mnt/media/tv/'
DESTDIR_PATH_FOR_MKDIR='/home/william/rt-testing/dest/'
DESTDIR_PATH_FOR_RTORRENT='/home/media/tv/'
DOWNLOAD_PATH_FOR_RSSDLER='/download/'
#PATH_TO_RTORRENT_CONFIG='/mnt/rtorrent-docker/rtorrent-home/.rtorrent.shows'
PATH_TO_RTORRENT_CONFIG="/home/william/rt-testing/rtorrent.shows"
#PATH_TO_RSSDLER_CONFIG='/mnt/rtorrent-docker/rssdler/config/config.txt'
PATH_TO_RSSDLER_CONFIG='/home/william/rt-testing/config.txt'

## get the last watchdir number and increment it
LAST_ITER=$(tail -1 ${PATH_TO_RTORRENT_CONFIG} | cut -d ',' -f 1 | cut -d '_' -f 3)
THIS_ITER=$(( $LAST_ITER + 1 ))

## tweak these if you need to change the config file formats at all
RSSDLER_CONFIG_CONTENT="\n[ ${SHOWNAME} ]\nlink=${SHOWURL}\ndirectory=${DOWNLOAD_PATH_FOR_RSSDLER}"
RTORRENT_CONFIG_CONTENT="\n##${SHOWNAME}\nschedule = watch_directory_${THIS_ITER},5,5,\"load.start_verbose=${WATCHDIR_PATH_FOR_RTORRENT}${SHOWNAME}/*.torrent,d.custom1.set=${DESTDIR_PATH_FOR_RTORRENT},d.delete_tied=\""

dirs_to_make="${WATCHDIR_PATH_FOR_MKDIR}${SHOWNAME} ${DESTDIR_PATH_FOR_MKDIR}${SHOWNAME}"

echo "$(which echo)"

echo "here's what we'll be doing:"
echo "dirs to make: $dirs_to_make"
echo -e "adding this to $PATH_TO_RTORRENT_CONFIG:
$RTORRENT_CONFIG_CONTENT"
echo -e "adding this to $PATH_TO_RSSDLER_CONFIG:
$RSSDLER_CONFIG_CONTENT"

echo ""
echo "making directories"
mkdir -p $dirs_to_make

echo "modding configs"
echo -e "${RTORRENT_CONFIG_CONTENT}" >> "${PATH_TO_RTORRENT_CONFIG}"
echo -e "${RSSDLER_CONFIG_CONTENT}" >> "${PATH_TO_RSSDLER_CONFIG}"
