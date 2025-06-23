#!bin/bash

DISPLAY_RE="([0-9]+)x([0-9]+)\\+([0-9]+)\\+([0-9]+)"
IMAGE_RE="([0-9]+)x([0-9]+)"

FOLDER="$(dirname "$readlink -f "$0")")"
LOCK="/home/aleksander/Dev/ProductivityScripts/i3lock-setup/lock.png"
TEXT="/home/aleksander/Dev/ProductivityScripts/i3lock-setup/text.png"

echo $LOCK

PIXELATE=true

OUTPUT="/home/aleksander/Pictures/Wallpapers/grab.png"
scrot -z $OUTPUT

PARAMS=""

LOCK_IMAGE_INFO=`identify $LOCK`
[[ $LOCK_IMAGE_INFO =~ $IMAGE_RE ]]
IMAGE_WIDTH=${BASH_REMATCH[1]}
IMAGE_HEIGHT=${BASH_REMATCH[2]}

if $DISPLAY_TEXT ; then
  #Get dimensions of the text image:
  TEXT_IMAGE_INFO=`identify $TEXT`
  [[ $TEXT_IMAGE_INFO =~ $IMAGE_RE ]]
  TEXT_WIDTH=${BASH_REMATCH[1]}
  TEXT_HEIGHT=${BASH_REMATCH[2]}
fi

while read LINE
do
  #If we are reading the line that contains the position information:
  if [[ $LINE =~ $DISPLAY_RE ]]; then
    #Extract information and append some parameters to the ones that will be given to ImageMagick:
    WIDTH=${BASH_REMATCH[1]}
    HEIGHT=${BASH_REMATCH[2]}
    X=${BASH_REMATCH[3]}
    Y=${BASH_REMATCH[4]}
    POS_X=$(($X+$WIDTH/2-$IMAGE_WIDTH/2))
    POS_Y=$(($Y+$HEIGHT/2-$IMAGE_HEIGHT/2))

    PARAMS="$PARAMS '$LOCK' '-geometry' '+$POS_X+$POS_Y' '-composite'"

    if $DISPLAY_TEXT ; then
        TEXT_X=$(($X+$WIDTH/2-$TEXT_WIDTH/2))
        TEXT_Y=$(($Y+$HEIGHT/2-$TEXT_HEIGHT/2+200))
        PARAMS="$PARAMS '$TEXT' '-geometry' '+$TEXT_X+$TEXT_Y' '-composite'"
    fi
  fi
done <<<"`xrandr`"

if $PIXELATE ; then
  PARAMS="'$OUTPUT' '-scale' '10%' '-scale' '1000%' $PARAMS '$OUTPUT'"
else
  PARAMS="'$OUTPUT' '-level' '0%,100%,0.6' '-blur' '$BLURTYPE' $PARAMS '$OUTPUT'"
fi

eval convert $PARAMS

i3lock -i $OUTPUT -t
