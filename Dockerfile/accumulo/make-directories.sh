#!/bin/bash

mkdir /opt/java

mkdir /geomesa

#Make data folders
mkdir -p /data/dfs/data
mkdir /data/dfs/namenode
mkdir /data/dfs/checkpoint
mkdir /data/zookeeper
mkdir -p /var/lib/hadoop-hdfs

mkdir /var/run/sshd
mkdir /root/.ssh

mkdir -p /opt/hadoop/hadoop-2.2.0/conf

mkdir /opt/zookeeper

mkdir /opt/accumulo

mkdir /opt/maven