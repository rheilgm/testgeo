#
# example dockerfile for geogig
#

FROM ubuntu:14.04
MAINTAINER charles.ott@ccri.com

USER root

RUN apt-get -y -q install wget

#Download

RUN unzip geogig-cli-app-1.0-beta1.zip
ENV PATH $PATH:geogig/bin

RUN mkdir /geogig-repo; cd /geogig-repo
RUN geogig init

CMD ["/bin/bash"]

