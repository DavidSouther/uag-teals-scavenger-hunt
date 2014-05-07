#!/bin/sh
ROOTDIR="$(cd "$(dirname $0)" && pwd | sed 's!/build/deploy/node!!')"
echo "Starting in $ROOTDIR"

source $ROOTDIR/env/environment.sh

# Check that we aren't already started
[ -f $ROOTDIR/run/node.pid ] && {
    echo "Node already running ($(cat $ROOTDIR/run/node.pid))!"
    exit 1;
}

# Start mongo, if needed
[ -f $ROOTDIR/run/mongo.pid ] || {
    sh $ROOTDIR/build/deploy/mongo/start.sh
    sleep 1 ;# Let mongod start
}

nohup \
node   $ROOTDIR/node_modules/.bin/supervisor \
    -w $ROOTDIR/build/server -e coffee \
       $ROOTDIR/build/deploy/node/start.js \
       > $ROOTDIR/run/node.log 2>&1 </dev/null \
       &

echo $! >| $ROOTDIR/run/node.pid
