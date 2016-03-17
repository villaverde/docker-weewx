FROM debian:jessie
MAINTAINER Tom Mitchell <tom@tom.org>

ENV VERSION=3.5.0
ENV HOME=/home/weewx

RUN apt-get -y update && apt-get -y upgrade

RUN apt-get install -y sqlite3 curl \
python-configobj python-cheetah python-imaging \
python-serial python-usb python-mysqldb

# install weewx from source
RUN curl http://weewx.com/downloads/weewx-$VERSION.tar.gz | tar xzC /tmp \
&& cd /tmp/weewx* && ./setup.py build && ./setup.py install --no-prompt

ENV TZ=America/New_York
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# go ahead an install the forecast extension

RUN apt-get -y install python-dev python-pip xtide

RUN pip install pyephem

RUN apt-get -y install wget

RUN apt-get -y install xtide

RUN wget http://lancet.mit.edu/mwall/projects/weather/releases/weewx-forecast-3.1.2.tgz

RUN /home/weewx/bin/wee_extension --install weewx-forecast-3.1.2.tgz

# add all confs and extras to the install
# based on CONF env, copy the dirs to the install using CMD cp

# override this to run another configuration
ENV CONF default

ADD conf/ $HOME/conf/
ADD bin/run.sh $HOME/
RUN chmod 755 $HOME/run.sh

CMD $HOME/run.sh

