#!/bin/sh
ROOTDIR="$(cd "$(dirname $0)" && pwd | sed 's!/src/deploy/node!!')"
echo "Starting in $ROOTDIR"

source $ROOTDIR/etc/environment.sh

[ -f $ROOTDIR/var/mongo.pid ] || $ROOTDIR/src/deploy/mongo/start.sh

sleep 1 # Let mongod start

node   $ROOTDIR/node_modules/.bin/supervisor \
    -w $ROOTDIR/src/server -e coffee \
       $ROOTDIR/src/deploy/node/start.js
