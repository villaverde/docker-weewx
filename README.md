Basic usage:

clone the git repo:

git clone https://github.com/mitct02/docker-weewx

Simple approach to customizing your instance:

Config:

You can either edit the contents of ./conf/default directly or
  put your own config(s) into any directory under ./config (e.g.)
  ./config/dev
  
  What you put in your own config can consist of skins, bin/user,
  templates, or whatever you want copied into the /home/weewx directory,
  which is where weewx will eventually be run.
  
Since the web content is small and transient, it is ok
  to mount a host directory to avoid the complexity of using a data
  volume (though it is still fine to do it that way)

Mount a host volume in /tmp to hold the html and inages:

docker run -d --name=weewx-webserver --restart=always -p 80:80 -v /tmp/httpdroot:/usr/local/apache2/htdocs httpd
docker run -d --name=weewx-default --restart=always -v /tmp/httpdroot:/home/weewx/public_html mitct02/weewx
