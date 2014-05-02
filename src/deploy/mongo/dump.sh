#!/bin/sh
ROOTDIR="$(cd "$(dirname $0)" && pwd | sed 's!/src/deploy/mongo!!')"
source $ROOTDIR/etc/environment.sh

DUMP=snapshot_$(date +%Y-%m-%dT%H-%M-%S)

mongodump --port $MONGO_PORT --out $DUMP
tar cf $DUMP.tar $DUMP
rm -rf $DUMP
