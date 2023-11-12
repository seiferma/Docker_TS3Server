#!/bin/sh

USER_NAME=ts3-server
GROUP_NAME=ts3-server

# Generating user account
echo "Generating user account"
if [ "$TS3_GID" == "" ]; then
	export TS3_GID=1000
fi
if [ "$TS3_UID" == "" ]; then
	export TS3_UID=1000
fi
addgroup -g $TS3_GID $GROUP_NAME
adduser -D -H -G $GROUP_NAME -u $TS3_UID $USER_NAME
chown $USER_NAME:$GROUP_NAME $DATA_VOLUME

# Initiliaze config
[ ! -f $DATA_VOLUME/ts3server.sqlitedb ] && touch $DATA_VOLUME/ts3server.sqlitedb && chown $USER_NAME:$GROUP_NAME $DATA_VOLUME/ts3server.sqlitedb
ln -s $DATA_VOLUME/ts3server.sqlitedb ts3server.sqlitedb
[ ! -f $DATA_VOLUME/logs ] && mkdir $DATA_VOLUME/logs  && chown $USER_NAME:$GROUP_NAME $DATA_VOLUME/logs
ln -s $DATA_VOLUME/logs logs
[ ! -f $DATA_VOLUME/files ] && mkdir $DATA_VOLUME/files  && chown $USER_NAME:$GROUP_NAME $DATA_VOLUME/files
ln -s $DATA_VOLUME/files files
export LANG=en_US.UTF-8
export TS3SERVER_LICENSE=accept

# Run server
if [ "$1" == "default" ]; then
        echo "Starting ts3 server"
        su-exec $USER_NAME ./ts3server_minimal_runscript.sh
else
	echo "Executing command"
	exec "$@"
fi
