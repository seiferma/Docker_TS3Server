FROM alpine:latest AS builder
ENV TS3_VERSION=3.13.5
WORKDIR /ts3

RUN wget https://files.teamspeak-services.com/releases/server/${TS3_VERSION}/teamspeak3-server_linux_amd64-${TS3_VERSION}.tar.bz2 -O server.tar.bz2 && \
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
    rm -rf serverquerydocs



FROM debian:stable-slim
WORKDIR /ts3

# Setup dependencies
RUN apt-get update && \
    apt-get install -y ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Copy ts3 server from builder
COPY --from=builder /ts3 /ts3/

# Add default configuration and start script
COPY ["ts3server.ini", "start.sh", "./"]

# Expose voice port
EXPOSE 9987/udp

# Define data mount point
ENV DATA_VOLUME=/data

# Configure user rights
RUN addgroup ts3 && \
    adduser --disabled-password --ingroup ts3 --home /ts3 --shell /bin/false ts3 && \
    chown -R ts3:ts3 ./ && \
    ls -la && \
    mkdir -p ${DATA_VOLUME} && \
    chown ts3:ts3 ${DATA_VOLUME}
USER ts3

# Define volume mount point
VOLUME ["${DATA_VOLUME}"]

# Start the server
ENTRYPOINT ["./start.sh"]
