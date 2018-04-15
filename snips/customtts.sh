#!/bin/sh

API_KEY=$1
PLATFORM=$2
FILE=$3
LANG=$4
TEXT=$5

if [ -z "$LANG" || $LANG == "null" ]; then
    LANG="en-US"
fi

RESPONSE=`curl -s -H "x-ha-access: $API_KEY" -H "Type: application/json" http://hassio.local:8123/api/tts_get_url -d '{"message": "$TEXT", "platform": "$PLATFORM", "language": "$LANG"}'`
echo $RESPONSE
URL=`echo $RESPONSE | jq --raw-output '.url'`

curl $URL -s -o /tmp/temp.mp3
/usr/bin/mpg123 -w $FILE /tmp/temp.mp3

#echo $URL

