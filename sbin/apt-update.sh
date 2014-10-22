#!/bin/bash
cd "$(dirname "$0")"
docker run -it --name=aptcache ubuntu:14.04 apt-get update
docker commit aptcache ubuntu:14.04
docker run -it --name=aptinstall ubuntu:14.04 apt-get -y install tar unzip nano python-yaml openssh-server openssh-client rsync
docker commit aptinstall ubuntu:14.04

