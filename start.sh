#!/bin/sh

[ ! -f $DATA_VOLUME/ts3server.sqlitedb ] && touch $DATA_VOLUME/ts3server.sqlitedb
ln -s $DATA_VOLUME/ts3server.sqlitedb ts3server.sqlitedb
export LANG=en_US.UTF-8
./ts3server_minimal_runscript.sh