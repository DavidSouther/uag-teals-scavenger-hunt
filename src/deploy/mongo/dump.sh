#!/bin/sh
ROOTDIR="$(cd "$(dirname $0)" && pwd | sed 's!/build/deploy/mongo!!')"
source $ROOTDIR/env/environment.sh
SNAPS=$ROOTDIR/snapshots

mkdir "$SNAPS"
TAG=${NODE_ENV}_$(date +%Y-%m-%dT%H-%M-%S)
DUMP="${SNAPS}/${TAG}"
set -x
mongodump --port $MONGO_PORT --out $DUMP
tar czf $DUMP.tgz $DUMP
rm -rf $DUMP
