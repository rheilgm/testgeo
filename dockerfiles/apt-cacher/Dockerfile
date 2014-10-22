#
# example ubuntu 14.04 apt-cacher
#

FROM ubuntu:14.04
MAINTAINER charles.ott@ccri.com

USER root
RUN apt-get update
RUN apt-get -y -q install apt-cacher nano
ADD apt-cacher.conf /etc/apt-cacher/apt-cacher.conf
ADD start-cacher.sh /root/start-cacher.sh
RUN chmod +x /root/start-cacher.sh
EXPOSE 3142


#Default Docker Run Comamnd(s)
CMD ["/root/start-cacher.sh"]

