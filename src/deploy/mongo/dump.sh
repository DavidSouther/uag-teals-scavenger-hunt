#!/bin/sh
ROOTDIR="$(cd "$(dirname $0)" && pwd | sed 's!/src/deploy/mongo!!')"

PORT=${MONGO_PORT:=27017}

DUMP=snapshot_$(date +%Y%m%d-%H%M%S)

mongodump --port $PORT --out $DUMP
tar cf $DUMP.tar $DUMP
rm -rf $DUMP
