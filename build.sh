#!/usr/bin/env bash
VERSION=3.9.1

docker build --no-cache -t mitct02/weewx:$VERSION .
docker tag mitct02/weewx:$VERSION mitct02/weewx:latest
