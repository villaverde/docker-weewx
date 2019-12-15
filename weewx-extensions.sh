#!/bin/bash

wget -O /tmp/weewx-interceptor.zip https://github.com/matthewwall/weewx-interceptor/archive/master.zip
/home/weewx/bin/wee_extension --install /tmp/weewx-interceptor.zip
/home/weewx/bin/wee_config --reconfigure --driver=user.interceptor --no-prompt
rm /tmp/weewx-interceptor.zip