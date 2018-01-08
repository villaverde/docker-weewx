Basic usage:

Create a Dockerfile with at least:

FROM mitct02/weewx:3.8.0 (use the version you prefer)

Insert the correct version or you could use latest.

Make a conf directory at the root of your working directory (where Dockerfile is).

Copy your configs into separate directories under ~/conf. For example, you may
have a config for dev, test, and prod. Or you may have a config for each location
where you have a weather station, or some other scheme. Each separate weewx instance is in its own config subdir.

Make a keys directory at the root of your working directory (where Dockerfile is). This is where you will store the public keys to be used for rsync. The content of this directory will be copied to /root/.ssh/ and will allow weewx to copy your web content to another box. You need this even if you do not plan to use rsync (but it can be an empty directory).

Then run docker build -t my-weewx

TL;DR - mkdir keys conf; HTTP_PORT=80 CONF=foo docker-compose up

Simple approach to customizing your instance:

Config:

You can either edit the contents of ./conf/default directly or
  put your own config(s) into a directory under ./conf (e.g.)
  ./conf/dev
  
  What you put in your own config can consist of skins, bin/user,
  templates, or whatever you want copied into the /home/weewx directory, which is where weewx will eventually be run inside its container.
  
Since the web content is small and transient, it is ok
  to mount a host directory to avoid the complexity of using a data
  volume (though it is still fine to do it that way). You can also run a web server
  container alongside weewx using something like docker-compose or Kubernetes.

To mount a host volume in /tmp to hold the html and images:

docker run -d --name=weewx-webserver --restart=always -p 80:80 -v 
/tmp/httpdroot:/usr/local/apache2/htdocs httpd

docker run -d --name=weewx-default --restart=always -e CONF=default -v /tmp/httpdroot:/home/weewx/public_html mitct02/weewx

