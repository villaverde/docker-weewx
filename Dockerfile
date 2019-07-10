FROM debian:jessie
MAINTAINER Tom Mitchell <tom@tom.org>

ENV VERSION=3.9.1
ENV HOME=/home/weewx

RUN apt-get -y update

RUN apt-get install -y apt-utils

# debian, ubuntu, mint, raspbian

# for systems that do not have python 2 installed (for example, ubuntu 18.04 and later):
RUN  apt-get install -y python

# for all systems, you may have to install the python imaging library. try this first:
RUN  apt-get install -y python-pil
# if that doesn't work, try this:
RUN  apt-get install -y python-imaging

# other required packages:
RUN  apt-get install -y python-configobj
RUN  apt-get install -y python-cheetah

# required if hardware is serial or USB:
RUN  apt-get install -y python-serial
RUN  apt-get install -y python-usb

# required if using MySQL:
RUN  apt-get install -y mysql-client
RUN  apt-get install -y python-mysqldb

# required if using FTP on Raspbian systems:
RUN  apt-get install -y ftp

# optional for extended almanac information:
RUN  apt-get install -y python-dev
RUN  apt-get install -y python-pip
RUN  pip install pyephem

RUN apt-get install -y sqlite3 curl python-pip python-dev rsync ssh git
#RUN pip install pyephem
# install weewx from source
ADD dist/weewx-$VERSION /tmp/
RUN cd /tmp && ./setup.py build && ./setup.py install --no-prompt
#CMD rm -rf /tmp/*

ENV TZ=America/New_York
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# add all confs and extras to the install
# based on CONF env, copy the dirs to the install using CMD cp

# override this env var to run another configuration
ENV CONF default

# The CONF env var should correspond to the name of a sub-dir under conf/
# ssh keys for rsync

RUN mkdir /root/.ssh
ADD conf/ $HOME/conf/
RUN chmod -R 777 $HOME
RUN chmod -R 600 /root/.ssh

ONBUILD ADD keys/* /root/.ssh/
ONBUILD RUN chmod -R 600 /root/.ssh
ONBUILD ADD conf/ $HOME/conf/
ONBUILD ADD skins/ $HOME/skins/
ONBUILD ADD bin/ $HOME/bin/

ADD bin/run.sh $HOME/
RUN chmod 755 $HOME/run.sh

WORKDIR $HOME

CMD $HOME/run.sh
