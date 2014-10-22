#!/bin/bash

if [ ! -f $JAVA_HOME/bin/java ]
    then
    tar -C /opt -xvf /tmp/jdk-7u67-linux-x64.tar.gz
   # wget -P /tmp --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/7u67-b01/jdk-7u67-linux-x64.tar.gz
    echo JAVA_HOME=/opt/jdk1.7.0_67 >> /etc/environment
fi

if [ ! -f $M2_HOME/bin/mvn ]
    then
  #  wget -P /tmp http://apache.arvixe.com/maven/maven-3/3.2.3/binaries/apache-maven-3.2.3-bin.tar.gz
    tar -C /opt -xvf /tmp/apache-maven-3.2.3-bin.tar.gz
    echo M2_HOME=/opt/apache-maven-3.2.3 >> /etc/environment
    echo PATH=$PATH:/opt/jdk1.7.0_67/bin:/opt/apache-maven-3.2.3/bin >> /etc/environment
fi
echo "Dont forget to re-login (or source /etc/environment)"
