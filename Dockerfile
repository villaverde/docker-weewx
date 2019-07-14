FROM debian:jessie
MAINTAINER Tom Mitchell <tom@tom.org>

ENV VERSION=3.9.1
ENV HOME=/home/weewx

RUN apt-get -y update

RUN apt-get install -y apt-utils

# debian, ubuntu, mint, raspbian

# for systems that do not have python 2 installed (for example, ubuntu 18.04 and later):
RUN  apt-get install -y python python-pil python-configobj python-cheetah python-serial python-usb \
mysql-client python-mysqldb ftp python-dev python-pip sqlite3 curl python-pip rsync ssh git

RUN  pip install pyephem

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
