#!/bin/sh
ROOTDIR="$(cd "$(dirname $0)" && pwd | sed 's!/src/deploy/mongo!!')"
source $ROOTDIR/etc/environment.sh

SNAP="$1"
SNAPDIR=${SNAP%\.tar}

tar xf $SNAP
mongorestore --port $MONGO_PORT $SNAPDIR
rm -rf $SNAPDIR
