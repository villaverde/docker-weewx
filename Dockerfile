FROM debian:jessie
MAINTAINER Tom Mitchell <tom@tom.org>

ENV VERSION=3.8.0
ENV HOME=/home/weewx

RUN apt-get -y update

RUN apt-get install -y apt-utils
RUN apt-get install -y sqlite3 curl \
python-configobj python-cheetah python-imaging \
python-serial python-usb python-mysqldb python-pip python-dev rsync ssh git
RUN pip install pyephem
# install weewx from source
ADD dist/weewx-$VERSION /tmp/
RUN cd /tmp && ./setup.py build && ./setup.py install --no-prompt

ENV TZ=America/New_York
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# add all confs and extras to the install
# based on CONF env, copy the dirs to the install using CMD cp

# override this env var to run another configuration
ENV CONF default

# The CONF env var should correspond to the name of a sub-dir under conf/
# ssh keys for rsync

RUN mkdir /root/.ssh
ONBUILD ADD keys/* /root/.ssh/
ONBUILD RUN chmod -R 600 /root/.ssh
ONBUILD ADD conf/ $HOME/conf/

ADD bin/run.sh $HOME/
RUN chmod 755 $HOME/run.sh

WORKDIR $HOME

CMD $HOME/run.sh
