#!/bin/sh
ROOTDIR="$(cd "$(dirname $0)" && pwd | sed 's!/src/deploy/mongo!!')"

LOGPATH="$ROOTDIR/var/mongo.log"
PIDPATH="$ROOTDIR/var/mongo.pid"
DBPATH="$ROOTDIR/var/db"

PORT=${MONGO_PORT:=27017}

mkdir -p $DBPATH
mongod --fork \
    --config /dev/null \
    --dbpath $DBPATH \
    --logpath $LOGPATH \
    --pidfilepath $PIDPATH \
    --port $PORT
