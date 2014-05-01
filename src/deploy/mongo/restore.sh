#!/bin/sh
ROOTDIR="$(cd "$(dirname $0)" && pwd | sed 's!/src/deploy/mongo!!')"

PORT=${MONGO_PORT:=27017}

SNAP="$1"
SNAPDIR=${SNAP%\.tar}

tar xf $SNAP
mongorestore --port $PORT $SNAPDIR
rm -rf $SNAPDIR
