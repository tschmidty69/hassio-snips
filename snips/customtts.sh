#!/bin/sh

API_KEY=$1
PLATFORM=$2
FILE=$3
LANG=$4
TEXT=$5

MESSAGE="'{\"message\": \"$TEXT\", \"platform\": \"$PLATFORM\"}'"

RESPONSE=$(eval curl -s -H \"x-ha-access: $API_KEY\" -H \"Type: application/json\" http://localhost:8123/api/tts_get_url -d $MESSAGE)
if [ "$RESPONSE" = "" ]; then
    exit 1
fi

URL=`echo $RESPONSE | jq --raw-output '.url'`
if [ "$URL" = "" ]; then
    exit 1
fi

rm /tmp/temp.mp3
curl -s -H "x-ha-access: $API_KEY" "$URL" -s -o /tmp/temp.mp3
if [ -f /tmp/temp.mp3 ]; then
  /usr/bin/mpg123 -w $FILE /tmp/temp.mp3
fi
rm /tmp/temp.mp3

