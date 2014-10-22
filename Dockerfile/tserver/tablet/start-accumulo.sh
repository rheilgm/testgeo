#!/bin/bash
rm /etc/pam.d/sshd
nohup /usr/sbin/sshd -D &
/opt/zookeeper/zookeeper-3.4.6/bin/zkServer.sh start
sed -i 's/localhost/'"$HOSTNAME"'/g' /opt/hadoop/hadoop-2.2.0/conf/core-site.xml
/opt/hadoop/hadoop-2.2.0/sbin/hadoop-daemon.sh --script hdfs start namenode
/opt/hadoop/hadoop-2.2.0/sbin/hadoop-daemon.sh --script hdfs start datanode
sleep 10
FILE="/opt/accumulo/accumulo-1.5.1/initialized"
if [ -f $FILE ]; then
        /opt/accumulo/accumulo-1.*/bin/start-all.sh
else
    touch $FILE
    echo -e "docker_instance\ntoor\ntoor\n" | /opt/accumulo/accumulo-1.*/bin/accumulo init
    sed -i 's/localhost/'"$HOSTNAME"'/g' /opt/accumulo/accumulo-1.*/conf/monitor
    sed -i 's/localhost/'"$HOSTNAME"'/g' /opt/accumulo/accumulo-1.*/conf/slaves
	sed -i 's/localhost/'"$HOSTNAME"'/g' /opt/accumulo/accumulo-1.*/conf/masters
    /opt/accumulo/accumulo-1.*/bin/start-all.sh
fi

bash
wait

