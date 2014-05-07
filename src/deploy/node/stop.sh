#!/bin/sh
ROOTDIR="$(cd "$(dirname $0)" && pwd | sed 's!/build/deploy/node!!')"

source $ROOTDIR/env/environment.sh

kill $(cat $ROOTDIR/run/node.pid)
rm $ROOTDIR/run/node.pid

sh $ROOTDIR/build/deploy/mongo/stop.sh
