#!/bin/bash

FILEPATH="/home/aleksander/Dropbox/Work/Timeliste/Timeliste.csv"

IFS=$'\n'

OUT=$(grep "." $FILEPATH | tail -6)

for line in $OUT; do
    if [[ ${line:0:1} == "#" ]]
    then
        NUMBER=$(echo $line | sed 's/[^0-9]*//g')
        echo $NUMBER
        NEXT=$(($NUMBER + 1))
        MOD=$(($NEXT % 10))
        if [[ $(($NEXT % 10 == 1)) == 0 ]]
        then
            EXTENSION="st"
        elif [[ $(($NEXT % 10 == 2)) == 0 ]]
        then
            EXTENSION="nd"
        elif [[ $(($NEXT % 10 == 3)) == 0 ]]
        then
            EXTENSION="rd"
        else
            EXTENSION="th"
        fi
        echo "#$NEXT$EXTENSION week" >> $FILEPATH
    else
        IFS="," read -ra array <<< "$line"
        DATE=${array[0]}
        NEXT_DATE=$(($DATE + 7))
        echo "$NEXT_DATE,," >> $FILEPATH
    fi
done
