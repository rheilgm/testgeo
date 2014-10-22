#!/bin/bash
rm /etc/pam.d/sshd
nohup /usr/sbin/sshd -D > sshd.out 2>&1&

sed -i 's/localhost/accumulo/g' /opt/hadoop/hadoop-2.2.0/conf/core-site.xml
#/opt/hadoop/hadoop-2.2.0/sbin/hadoop-daemon.sh --script hdfs start datanode
# datanode currently not working because of dns lookup failure. i think.
sleep 5
sed -i 's/localhost/'"$HOSTNAME"'/g' /opt/accumulo/accumulo-1.*/conf/slaves
sed -i 's/localhost/accumulo/g' /opt/accumulo/accumulo-1.*/conf/masters
sed -i 's/localhost/accumulo/g' /opt/accumulo/accumulo-1.*/conf/accumulo-site.xml

/opt/accumulo/accumulo-1.*/bin/accumulo tserver --address $PUBLIC_IP

bash
wait

