ARG BUILD_FROM
FROM $BUILD_FROM

# Copy data
COPY run.sh /
COPY mosquitto.conf /etc/
COPY asoundrc /root/.asoundrc

RUN chmod a+x /run.sh
RUN apk add --no-cache curl
RUN curl -Lso /share/assistant.zip https://github.com/tschmidty69/hassio-snips/releases/download/0.1-pre1/assistant.zip

ENTRYPOINT [ "/run.sh" ]
