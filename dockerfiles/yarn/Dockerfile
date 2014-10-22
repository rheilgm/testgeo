#
# yarn/mapreduce
#

FROM ubuntu:14.04
MAINTAINER charles.ott@ccri.com

USER root

# Make all needed directories in two steps
ADD make-directories.sh /opt/make-directories.sh
RUN /opt/make-directories.sh

# Add all files at once
ADD build-files.tar /root/

#Install JDK
RUN tar -C /opt/java -xzf /root/tmp/jdk-7u67-linux-x64.tar.gz
ENV JAVA_HOME /opt/java/jdk1.7.0_67
ENV PATH $PATH:$JAVA_HOME/bin

#Passwordless SSH
RUN ssh-keygen -t dsa -P '' -f /root/.ssh/id_dsa
RUN cat /root/.ssh/id_dsa.pub >> /root/.ssh/authorized_keys
RUN echo "StrictHostKeyChecking no" >> /root/.ssh/config

# Hadoopin!!!
#Install Hadoop
RUN tar -C /opt/hadoop -xzf /root/tmp/hadoop-2.2.0.tar.gz
ENV HADOOP_INSTALL /opt/hadoop/hadoop-2.2.0
ENV PATH $PATH:$HADOOP_INSTALL/bin
ENV PATH $PATH:$HADOOP_INSTALL/sbin
ENV HADOOP_MAPRED_HOME $HADOOP_INSTALL
ENV HADOOP_COMMON_HOME $HADOOP_INSTALL
ENV HADOOP_HDFS_HOME $HADOOP_INSTALL
ENV YARN_HOME $HADOOP_INSTALL

#Configure Hadoop
RUN mv /root/hadoop-env.sh /opt/hadoop/hadoop-2.2.0/conf/hadoop-env.sh
RUN mv /root/core-site.xml /opt/hadoop/hadoop-2.2.0/conf/core-site.xml
RUN mv /root/hdfs-site.xml /opt/hadoop/hadoop-2.2.0/conf/hdfs-site.xml
RUN mv /root/mapred-site.xml /opt/hadoop/hadoop-2.2.0/conf/mapred-site.xml
RUN mv /root/profile /etc/profile
RUN mv /root/yarn-site.xml /opt/hadoop/hadoop-2.2.0/conf/yarn-site.xml
RUN mv /root/slaves /opt/hadoop/hadoop-2.2.0/conf/slaves
RUN mv /root/capacity-scheduler.xml /opt/hadoop/hadoop-2.2.0/conf/capacity-scheduler.xml

EXPOSE 8088 8042

RUN mv /root/start-yarn.sh /opt/start-yarn.sh
RUN chmod +x /opt/start-yarn.sh
CMD ["/opt/start-yarn.sh"]
