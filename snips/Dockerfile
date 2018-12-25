ARG BUILD_FROM
FROM $BUILD_FROM

# Copy data
COPY run.sh /
COPY mosquitto.conf /etc/
COPY customtts.sh /usr/bin
COPY snips-entrypoint.sh /

RUN echo nameserver 1.1.1.1 > /etc/resolv.conf \
    && apt update \
    && apt-get install -y dirmngr apt-utils apt-transport-https jq unzip supervisor \
                          mpg123 curl tzdata \
    && bash -c  'echo "deb https://raspbian.snips.ai/stretch stable main" > /etc/apt/sources.list.d/snips.list' \
    && apt-key adv --keyserver pgp.surfnet.nl --recv-keys D4F50CDCA10A2849 \
    && apt update \
    && apt install -y snips-platform-voice \
    && chmod a+x /run.sh \
    && chmod a+x /usr/bin/customtts.sh \
    && chmod a+x /snips-entrypoint.sh \
    && rm -rf /var/lib/apt/lists/* \
    && curl -L -o /assistant_Hass_de.zip https://s3.amazonaws.com/hassio-addons-data/assistant_Hass_de.zip \
    && curl -L -o /assistant_Hass_en.zip https://s3.amazonaws.com/hassio-addons-data/assistant_Hass_en.zip \
    && curl -L -o /assistant_Hass_fr.zip https://s3.amazonaws.com/hassio-addons-data/assistant_Hass_fr.zip

ENTRYPOINT [ "/run.sh" ]
