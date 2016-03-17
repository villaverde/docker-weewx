#!/usr/bin/env bash

# HOME=/home/weewx is set by the Dockerfile but can be overridden in run command
echo "using $CONF"

cp -rv $HOME/conf/$CONF/* /home/weewx/

CONF_FILE=/home/weewx/weewx.conf

while true; do echo 'Hit CTRL+C'; $HOME/bin/weewxd $CONF_FILE; sleep 10; done
