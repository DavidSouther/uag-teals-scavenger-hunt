#!/bin/sh
ROOTDIR="$(cd "$(dirname $0)" && pwd | sed 's!/build/deploy/mongo!!')"
source $ROOTDIR/env/environment.sh

PIDPATH="$ROOTDIR/run/mongo.pid"

kill $(cat $PIDPATH)
rm $PIDPATH
