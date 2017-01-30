#!/usr/bin/env bash

# HOME=/home/weewx is set by the Dockerfile but can be overridden in run command
echo "using $CONF"

cp -rv $HOME/conf/$CONF/* /home/weewx/

CONF_FILE=$HOME/weewx.conf

./bin/weewxd $CONF_FILE
