#
# example dockerfile for zk,accumulo,jdk,hdfs
#

FROM ubuntu:12.04
MAINTAINER charles.ott@ccri.com

USER root

RUN apt-get -y -q install tar unzip

#Install JDK
RUN mkdir /opt/java
ADD jdk-7u60-linux-x64.tar.gz /opt/java
ENV JAVA_HOME /opt/java/jdk1.7.0_60
ENV PATH $PATH:$JAVA_HOME/bin

#Install Zk
RUN mkdir /opt/zookeeper
ADD zookeeper-3.4.6.tar.gz /opt/zookeeper
ENV ZOOKEEPER_HOME /opt/zookeeper/zookeeper-3.4.6
ENV PATH $PATH:$ZOOKEEPER_HOME/bin
#Configure Zk
ADD zoo.cfg /opt/zookeeper/zookeeper-3.4.6/conf/zoo.cfg
EXPOSE 2181


# Add VOLUMEs to allow backup of config, logs and databases
VOLUME  ["/tmp/zookeeper"]

#Default Docker Run Comamnd(s)
CMD ["/opt/zookeeper/zookeeper-3.4.6/bin/zkServer.sh", "start-foreground"]

