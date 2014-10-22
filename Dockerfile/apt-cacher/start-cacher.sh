#!/bin/bash
/usr/sbin/apt-cacher -R 3 -d -p /var/run/apt-cacher.pid
tail -f /var/log/apt-cacher/access.log
wait
