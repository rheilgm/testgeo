#
# Dockerfile for Accumulo 1.5.2 with HDFS 2.2.0 and Geomesa 1.x
#

FROM ubuntu:14.04
MAINTAINER charles.ott@ccri.com

USER root

#RUN apt-get update
#RUN apt-get -y -q install openssh-server openssh-client rsync

# Make all needed directories in two steps
ADD make-directories.sh /opt/make-directories.sh
RUN /opt/make-directories.sh

# Add all files at once
ADD build-files.tar /root/

# Set all ENVs
ENV JAVA_HOME /opt/java/jdk1.7.0_67
ENV PATH $PATH:$JAVA_HOME/bin
ENV HADOOP_HOME /opt/hadoop/hadoop-2.2.0
ENV HADOOP_COMMON_LIB_NATIVE_DIR $HADOOP_HOME/lib/native
ENV HADOOP_OPTS -Djava.library.path=$HADOOP_HOME/lib
ENV PATH $PATH:$HADOOP_HOME/bin
ENV ZOOKEEPER_HOME /opt/zookeeper/zookeeper-3.4.6
ENV ACCUMULO_HOME /opt/accumulo/accumulo-1.5.2
ENV M2_HOME /opt/maven/apache-maven-3.2.3
ENV GEOMESA_HOME /geomesa/geomesa-1.0.0-SNAPSHOT/
ENV PATH $PATH:$ZOOKEEPER_HOME/bin:$ACCUMULO_HOME/bin:$M2_HOME/bin:$GEOMESA_HOME/bin

#Install JDK
RUN tar -C /opt/java -xzf /root/tmp/jdk-7u67-linux-x64.tar.gz

#Install Hadoop
RUN tar -C /opt/hadoop -xzf /root/tmp/hadoop-2.2.0.tar.gz

#Passwordless SSH
RUN ssh-keygen -t dsa -P '' -f /root/.ssh/id_dsa
RUN cat /root/.ssh/id_dsa.pub >> /root/.ssh/authorized_keys
RUN echo "StrictHostKeyChecking no" >> /root/.ssh/config

#Configure Hadoop
RUN mv /root/hadoop-env.sh /opt/hadoop/hadoop-2.2.0/conf/hadoop-env.sh
RUN mv /root/core-site.xml /opt/hadoop/hadoop-2.2.0/conf/core-site.xml
RUN mv /root/hdfs-site.xml /opt/hadoop/hadoop-2.2.0/conf/hdfs-site.xml
RUN mv /root/mapred-site.xml /opt/hadoop/hadoop-2.2.0/conf/mapred-site.xml
RUN mv /root/profile /etc/profile
RUN mv /root/libhadoop.so.1.0.0 /opt/hadoop/hadoop-2.2.0/lib/native/libhadoop.so.1.0.0
RUN mkdir /var/lib/hadoop-hdfs
RUN hadoop namenode -format

#Install Zk
RUN tar -C /opt/zookeeper -xzf /root/tmp/zookeeper-3.4.6.tar.gz

#Configure Zk
RUN mv /root/zoo.cfg /opt/zookeeper/zookeeper-3.4.6/conf/zoo.cfg

#Install Accumulo
RUN tar -C /opt/accumulo -xzf /root/tmp/accumulo-1.5.2-bin.tar.gz

# Omit this line when using external volumes for dependencies
RUN mv /root/geomesa-dist-runtime.jar /opt/accumulo/accumulo-1.5.2/lib/ext/

#Configure Accumulo
RUN cp /opt/accumulo/accumulo-1.5.2/conf/examples/1GB/standalone/* /opt/accumulo/accumulo-1.5.2/conf/.
RUN echo "vm.swappiness = 0" >> /etc/sysctl.conf
RUN mv /root/accumulo-site-1.5.2.xml /opt/accumulo/accumulo-1.5.2/conf/accumulo-site.xml
RUN mv /root/accumulo-env-1.5.2.sh /opt/accumulo/accumulo-1.5.2/conf/accumulo-env.sh

#Zk/Hadoop/Accumulo Ports
EXPOSE 2181 50070 50095 22 9000 50075

#untar geomesa tools
RUN tar -C /geomesa -xvf /root/geomesa-tools.tar.gz

#log4j/slf4j fix
RUN mv /root/log4j-1.2.17.jar /geomesa/geomesa-1.0.0-SNAPSHOT/lib/
RUN mv /root/slf4j-log4j12-1.7.5.jar /geomesa/geomesa-1.0.0-SNAPSHOT/lib/

#Default Docker Run Comamnd(s)
RUN chmod +x /root/start-accumulo.sh
CMD ["/root/start-accumulo.sh"]
