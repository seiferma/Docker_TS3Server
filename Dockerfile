FROM seiferma/alpine-glibc:latest
ENV TS3_VERSION=3.8.0

WORKDIR /ts3

# Setup ts3 server
RUN wget http://dl.4players.de/ts/releases/${TS3_VERSION}/teamspeak3-server_linux_amd64-${TS3_VERSION}.tar.bz2 -O server.tar.bz2 && \
    tar xjf server.tar.bz2 && \
    rm server.tar.bz2 && \
    mv teamspeak3-server_linux_amd64/* ./ && \
    rm -r teamspeak3-server_linux_amd64 && \
    rm -f libts3db_mariadb.so && \
    rm -rf doc && \
    rm -f LICENSE && \
    rm -f CHANGELOG && \
    rm -rf tsdns && \
    rm -f ts3server_startscript.sh && \
    rm -rf redist && \
    rm -rf serverquerydocs && \
    apk --no-cache add ca-certificates && \
    TS3_VERSION=

# Add default configuration and start script
COPY ["ts3server.ini", "start.sh", "./"]

# Expose voice port
EXPOSE 9987/udp

# Define data mount point
ENV DATA_VOLUME=/data

# Configure user rights
RUN addgroup ts3 && \
    adduser -G ts3 -h /ts3 -s /bin/false -D ts3 && \
    chown -R ts3:ts3 ./ && \
    mkdir -p ${DATA_VOLUME} && \
    chown ts3:ts3 ${DATA_VOLUME}
USER ts3

# Define volume mount point
VOLUME ["${DATA_VOLUME}"]

# Start the server
ENTRYPOINT ["./start.sh"]
