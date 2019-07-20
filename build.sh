#!/usr/bin/env bash
VERSION=3.9.2

docker build -t mitct02/weewx:$VERSION .
docker tag mitct02/weewx:$VERSION mitct02/weewx:latest
