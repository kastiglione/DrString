#!/bin/bash

if ! command -v docker > /dev/null; then
    echo "Install docker https://docker.com" >&2
    exit 1
fi
action=$1
swift=$2
ubuntu=$3
dockerfile=$(mktemp)
echo "FROM swift:$swift-$ubuntu"    >  $dockerfile
echo 'ADD . DrString'               >> $dockerfile
echo 'WORKDIR DrString'             >> $dockerfile
echo "RUN make $action"             >> $dockerfile
image=drstring
docker image rm -f "$image" > /dev/null
docker build -t "$image" -f $dockerfile .
docker run --rm "$image"
