#!/bin/sh
ROOTDIR="$(cd "$(dirname $0)" && pwd | sed 's!/src/deploy/mongo!!')"
source $ROOTDIR/etc/environment.sh

LOGPATH="$ROOTDIR/var/mongo.log"
PIDPATH="$ROOTDIR/var/mongo.pid"
DBPATH="$ROOTDIR/var/db"

mkdir -p $DBPATH
mongod --fork \
    --config /dev/null \
    --dbpath $DBPATH \
    --logpath $LOGPATH \
    --pidfilepath $PIDPATH \
    --port $MONGO_PORT \
    $MONGO_OPTS
