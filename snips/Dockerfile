#ARG BUILD_FROM
#FROM $BUILD_FROM
FROM snipsdocker/platform:x86-latest

# Copy data
COPY run.sh /
COPY mosquitto.conf /etc/
COPY asoundrc /root/.asoundrc
COPY mpg123* /usr/bin/
COPY customtts.sh /usr/bin
COPY assistant.zip /assistant-default.zip

RUN chmod a+x /run.sh

ENTRYPOINT [ "/run.sh" ]
