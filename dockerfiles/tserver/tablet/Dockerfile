#
# example dockerfile for zk,accumulo,jdk,hdfs
#

FROM ubuntu:14.04
MAINTAINER charles.ott@ccri.com

USER root

RUN apt-get update
RUN apt-get -y -q install openssh-server openssh-client rsync python-yaml
RUN mkdir /data


#Install JDK
RUN mkdir /opt/java
ADD http://art.ccri.com:8081/artifactory/ext-release-local/jdk/jdk/7u67-linux/jdk-7u67-linux-x64.tar.gz /opt/java/
RUN tar -C /opt/java -xzf /opt/java/jdk-7u67-linux-x64.tar.gz
ENV JAVA_HOME /opt/java/jdk1.7.0_67
ENV PATH $PATH:$JAVA_HOME/bin


#Make data folders
RUN mkdir /data/dfs
RUN mkdir /data/dfs/data
RUN mkdir /data/dfs/namenode
RUN mkdir /data/dfs/checkpoint
RUN mkdir /data/zookeeper

#Install Hadoop
RUN mkdir /opt/hadoop
#ADD http://art.ccri.com:8081/artifactory/ext-release-local/hadoop/hadoop/2.4.1.tar/hadoop-2.4.1.tar.gz /opt/hadoop/
RUN wget -P /opt/hadoop https://archive.apache.org/dist/hadoop/core/hadoop-2.2.0/hadoop-2.2.0.tar.gz
RUN tar -C /opt/hadoop -xzf /opt/hadoop/hadoop-2.2.0.tar.gz

#Passwordless SSH
# RUN mkdir /var/run/sshd
RUN mkdir /root/.ssh
RUN ssh-keygen -t dsa -P '' -f /root/.ssh/id_dsa
RUN cat /root/.ssh/id_dsa.pub >> /root/.ssh/authorized_keys
RUN echo "StrictHostKeyChecking no" >> /root/.ssh/config

#Configure Hadoop
RUN mkdir /opt/hadoop/hadoop-2.2.0/conf
ADD hadoop-env.sh /opt/hadoop/hadoop-2.2.0/conf/hadoop-env.sh
ADD core-site.xml /opt/hadoop/hadoop-2.2.0/conf/core-site.xml
ADD hdfs-site.xml /opt/hadoop/hadoop-2.2.0/conf/hdfs-site.xml
ADD mapred-site.xml /opt/hadoop/hadoop-2.2.0/conf/mapred-site.xml
ADD profile /etc/profile
ENV HADOOP_HOME /opt/hadoop/hadoop-2.2.0
ENV HADOOP_COMMON_LIB_NATIVE_DIR $HADOOP_HOME/lib/native
ENV HADOOP_OPTS -Djava.library.path=$HADOOP_HOME/lib
ENV PATH $PATH:$HADOOP_HOME/bin
RUN hadoop namenode -format

#Install Zk
RUN mkdir /opt/zookeeper
ADD http://art.ccri.com:8081/artifactory/ext-release-local/zookeeper/zookeeper/3.4.6.tar/zookeeper-3.4.6.tar.gz /opt/zookeeper/
RUN tar -C /opt/zookeeper -xzf /opt/zookeeper/zookeeper-3.4.6.tar.gz 
ENV ZOOKEEPER_HOME /opt/zookeeper/zookeeper-3.4.6
ENV PATH $PATH:$ZOOKEEPER_HOME/bin
#Configure Zk
ADD zoo.cfg /opt/zookeeper/zookeeper-3.4.6/conf/zoo.cfg

#Install Accumulo
RUN mkdir /opt/accumulo
ADD http://art.ccri.com:8081/artifactory/ext-release-local/accumulo/accumulo/1.5.1/accumulo-1.5.1-bin.tar.gz /opt/accumulo/
RUN tar -C /opt/accumulo -xzf /opt/accumulo/accumulo-1.5.1-bin.tar.gz

#Geomesa Plugin
# geomesa deps are fetched from artifactory using the attached YAML
# Deps go here: /opt/accumulo/accumulo-1.5.1/lib/ext/
ADD gavc-find.py /root/gavc-find.py
RUN chmod +x /root/gavc-find.py
ADD accumulo-deps.yaml /root/accumulo-deps.yaml
RUN /root/gavc-find.py /root/accumulo-deps.yaml
RUN mv deps/* /opt/accumulo/accumulo-1.5.1/lib/ext/

#Configure Accumulo
ENV ACCUMULO_HOME /opt/accumulo/accumulo-1.5.1
RUN cp /opt/accumulo/accumulo-1.5.1/conf/examples/1GB/standalone/* /opt/accumulo/accumulo-1.5.1/conf/.
RUN echo "vm.swappiness = 0" >> /etc/sysctl.conf
ADD accumulo-site-1.5.1.xml /opt/accumulo/accumulo-1.5.1/conf/accumulo-site.xml
ADD accumulo-env-1.5.1.sh /opt/accumulo/accumulo-1.5.1/conf/accumulo-env.sh

#Zk/Hadoop/Accumulo Ports
EXPOSE 2181
EXPOSE 50070
EXPOSE 50095
EXPOSE 22

#Default Docker Run Comamnd(s)
ADD start-accumulo.sh /root/start-accumulo.sh
RUN chmod +x /root/start-accumulo.sh
CMD ["/root/start-accumulo.sh"]
