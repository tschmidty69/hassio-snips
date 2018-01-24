#!/bin/bash
set -e

CONFIG_PATH=/data/options.json

MQTT_BRIDGE=$(jq --raw-output '.mqtt_bridge.active' $CONFIG_PATH)
ASSISTANT=$(jq --raw-output '.assistant' $CONFIG_PATH)
SPEAKER=$(jq --raw-output '.speaker' $CONFIG_PATH)
MIC=$(jq --raw-output '.mic' $CONFIG_PATH)

echo "[Info] Show audio output device"
aplay -l

echo "[Info] Show audio input device"
arecord -l

echo "[Info] Setup audio device"
sed -i "s/%%SPEAKER%%/$SPEAKER/g" /root/.asoundrc
sed -i "s/%%MIC%%/$MIC/g" /root/.asoundrc

# mqtt bridge
if [ "$MQTT_BRIDGE" == "true" ]; then
    HOST=$(jq --raw-output '.mqtt_bridge.host' $CONFIG_PATH)
    PORT=$(jq --raw-output '.mqtt_bridge.port' $CONFIG_PATH)
    USER=$(jq --raw-output '.mqtt_bridge.user' $CONFIG_PATH)
    PASSWORD=$(jq --raw-output '.mqtt_bridge.password' $CONFIG_PATH)

    echo "[Info] Setup internal mqtt bridge"

    {
        echo "connection main-mqtt"
        echo "address $HOST:$PORT"
    } >> /etc/mosquitto.conf

    if [ ! -z "$USER" ]; then
      {
          echo "username $USER"
          echo "password $PASSWORD"
      } >> /etc/mosquitto.conf
    fi

    {
        echo "topic # OUT"
        echo "topic hermes/intent/# out"
        echo "topic hermes/hotword/toggleOn out"
        echo "topic hermes/hotword/toggleOff out"
        echo "topic hermes/asr/stopListening out"
        echo "topic hermes/asr/startListening out"
        echo "topic hermes/nlu/intentNotParsed out"
        echo "topic # IN hermes/"
    } >> /etc/mosquitto.conf
fi

echo "[Info] Start internal mqtt broker"
mosquitto -c /etc/mosquitto.conf &

# init snips config
mkdir -p "$SNIPS_CONFIG"

echo "[Info] Fetching assistant"
curl -Lso /share/assistant.zip https://github.com/tschmidty69/hassio-snips/releases/download/0.1-pre1/assistant.zip

echo "[Info] Checking for updated $ASSISTANT in /share"
# check if a new assistant file exists
if [ -f "/share/$ASSISTANT" ]; then
    echo "[Info] Install/Update snips assistant"
    unzip -o -u "/share/$ASSISTANT" -d /usr/share/snips
fi

ln -s /etc/snips.toml /data

/opt/snips/snips-entrypoint.sh --mqtt localhost:1883
