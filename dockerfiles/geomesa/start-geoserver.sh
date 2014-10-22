#!/bin/bash
cd /opt/geoserver-2.5.2/
#fix for jar bug
rm /opt/geoserver-2.5.2/webapps/geoserver/WEB-INF/lib/commons-lang-2.1.jar
/opt/geoserver-2.5.2/bin/startup.sh & 
/usr/sbin/sshd -D &
bash
wait

