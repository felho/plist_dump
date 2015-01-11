#!/bin/sh


if [ "$1" == "diff" ]; then
  DUMP_NAME=$(ls -t $HOME/plist_dump | head -n 1)
  DUMP_DIR="$HOME/plist_dump/$DUMP_NAME"

  PREV_DUMP_NAME=$(ls -t $HOME/plist_dump | head -n 2 | tail -n 1)
  PREV_DUMP_DIR="$HOME/plist_dump/$PREV_DUMP_NAME"


  diff $PREV_DUMP_DIR $DUMP_DIR -x "diff"
  exit
fi


DUMP_NAME=$1
if [ "$1" == "" ]; then
	DUMP_NAME=$(date +"%Y-%m-%d_%H-%M-%S")
fi
DUMP_DIR="$HOME/plist_dump/$DUMP_NAME"

PREV_DUMP_NAME=$2
if [ "$2" == "" ]; then
  PREV_DUMP_NAME=$(ls -t $HOME/plist_dump | head -n 1)
fi
PREV_DUMP_DIR="$HOME/plist_dump/$PREV_DUMP_NAME"


mkdir -p $DUMP_DIR

sudo -v

# a /Data/Library/Preferences/ szurese azert kellett, mert a find vegig megy a symlinkeken
#for PLIST_FILE in $(sudo find / -name "*.plist"|grep -Ev "Xcode.app|PrivateFrameworks|iPhoto.app|iMovie.app|ApplicationServices.framework|BJPrinter|CharacterPalette.app|Library[_/]Frameworks|Library[_/]Extensions|Library[_/]CoreServices|/Data/Library/Preferences/"); do 
for PLIST_FILE in $(sudo find / -name "*.plist"|grep "/Preferences/"|grep -Ev "Xcode.app|PrivateFrameworks|iPhoto.app|iMovie.app|ApplicationServices.framework|BJPrinter|CharacterPalette.app|Library[_/]Frameworks|Library[_/]Extensions|Library[_/]CoreServices|/Data/Library/Preferences/"); do 
	OUTPUT_FILE="$DUMP_DIR/$(echo $PLIST_FILE|sed -E 's/\//_/g')";
	sudo plutil -p $PLIST_FILE > $OUTPUT_FILE;
done;

diff $PREV_DUMP_DIR $DUMP_DIR -x "diff"