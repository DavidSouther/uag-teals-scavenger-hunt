#!/bin/sh
ROOTDIR="$(cd "$(dirname $0)" && pwd | sed 's!/src/deploy!!')"
echo "Starting in $ROOTDIR"

source $ROOTDIR/etc/environment.sh

[ -f $ROOTDIR/var/mongo.pid ] || $ROOTDIR/src/deploy/mongo/start.sh

node   $ROOTDIR/node_modules/.bin/supervisor \
    -w $ROOTDIR/src/server -e coffee \
       $ROOTDIR/src/deploy/start.js
