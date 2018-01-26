#ARG BUILD_FROM
#FROM $BUILD_FROM
FROM snipsdocker/platform:x86-0.51.14

# Copy data
COPY run.sh /
COPY mosquitto.conf /etc/
COPY asoundrc /root/.asoundrc

RUN chmod a+x /run.sh

ENTRYPOINT [ "/run.sh" ]
