#
# Dockerfile for creating 64-bit hadoop 2.2.0 native lib.
#

FROM ubuntu:14.04
MAINTAINER charles.ott@ccri.com

USER root
RUN apt-get update
RUN apt-get install -y build-essential g++ autoconf automake libtool cmake zlib1g-dev pkg-config libssl-dev maven

ADD https://protobuf.googlecode.com/files/protobuf-2.5.0.tar.gz /root/protobuf-2.5.0.tar.gz

RUN tar -C /root/ -zxvf /root/protobuf-2.5.0.tar.gz
RUN cd /root/protobuf-2.5.0
RUN ./configure --prefix=/usr
RUN make
RUN make check
RUN make install

ADD https://archive.apache.org/dist/hadoop/core/hadoop-2.2.0/hadoop-2.2.0-src.tar.gz /root/hadoop-2.2.0-src.tar.gz
RUN tar -C /root/ -zxvf /root/hadoop-2.2.0-src.tar.gz
RUN cd /root/hadoop-2.2.0-src
RUN mvn package -Pdist,native -DskipTests -Dtar

# docker run w/ bin/bash and then need to implement fix here: http://www.drweiwang.com/build-hadoop-native-libraries/
