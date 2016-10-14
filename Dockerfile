FROM debian:jessie
MAINTAINER Tom Mitchell <tom@tom.org>

ENV VERSION=3.6.1
ENV HOME=/home/weewx

RUN apt-get -y update

RUN apt-get install -y sqlite3 curl \
python-configobj python-cheetah python-imaging \
python-serial python-usb python-mysqldb

# install weewx from source
RUN curl http://weewx.com/downloads/weewx-$VERSION.tar.gz | tar xzC /tmp \
&& cd /tmp/weewx* && ./setup.py build && ./setup.py install --no-prompt

ENV TZ=America/New_York
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# add all confs and extras to the install
# based on CONF env, copy the dirs to the install using CMD cp

# override this to run another configuration
ENV CONF default

ADD conf/ $HOME/conf/
ADD bin/run.sh $HOME/
RUN chmod 755 $HOME/run.sh

CMD $HOME/run.sh
