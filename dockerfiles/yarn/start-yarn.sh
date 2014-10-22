#!/bin/bash

rm /etc/pam.d/sshd
nohup /usr/sbin/sshd -D &
/opt/hadoop/hadoop-2.2.0/sbin/start-yarn.sh &
bash
wait