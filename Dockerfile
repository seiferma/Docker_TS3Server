FROM alpine:latest AS builder
ARG TS3_VERSION
WORKDIR /ts3

RUN wget https://files.teamspeak-services.com/releases/server/${TS3_VERSION}/teamspeak3-server_linux_alpine-${TS3_VERSION}.tar.bz2 -O server.tar.bz2 && \
    tar xjf server.tar.bz2 && \
    rm server.tar.bz2 && \
    mv teamspeak3-server_linux_alpine/* ./ && \
    rm -r teamspeak3-server_linux_alpine && \
    rm -f libts3db_mariadb.so && \
    rm -rf doc && \
    rm -f LICENSE && \
    rm -f CHANGELOG && \
    rm -rf tsdns && \
    rm -f ts3server_startscript.sh && \
    rm -rf redist && \
    rm -rf serverquerydocs



FROM alpine:3.23
WORKDIR /ts3

# Setup dependencies
RUN apk add --no-cache ca-certificates libstdc++ su-exec

# Copy ts3 server from builder
COPY --from=builder /ts3 /ts3/

# Add default configuration and start script
COPY ["ts3server.ini", "start.sh", "query_ip_denylist.txt", "./"]
RUN touch ssh_host_rsa_key query_ip_whitelist.txt && \
    chmod 777 ssh_host_rsa_key

# Expose voice port
EXPOSE 9987/udp

# Define data mount point
ENV DATA_VOLUME=/data

# Add data directory
RUN mkdir -p ${DATA_VOLUME}

# Define volume mount point
VOLUME ["${DATA_VOLUME}"]

# Start the server
ENTRYPOINT ["./start.sh"]
CMD ["default"]
