#!/bin/bash
cd "$(dirname "$0")"
#Update our local package index
sudo apt-get update

#Make sure Apt supports HTTPS
[ -e /usr/lib/apt/methods/https ] || {
  apt-get install apt-transport-https
}

# Get server key for repo
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9

# Update Repo Sources...
[ -e /etc/apt/sources.list.d/docker.list ] || {
  rm /etc/apt/sources.list.d/docker.list
}
sudo echo "deb https://get.docker.io/ubuntu docker main" > /etc/apt/sources.list.d/docker.list
sudo apt-get update

# ensure  Linux kernel extra modules are installed which support cpu cgroups, etc...
sudo apt-get install -y linux-image-extra-$(uname -r)

# Update package index and install docker
sudo apt-get install -y lxc-docker

# update docker DNS and listen on localhost tcp
sudo echo 'DOCKER_OPTS="-dns 8.8.8.8 -H unix:///var/run/docker.sock -H tcp://127.0.0.1:5555"' > /etc/default/docker

# Install python deps for ccri scripts
sudo apt-get install -y python-pip python-yaml
sudo pip install docker-py
sudo usermod -a -G docker $USER

sudo service docker restart

echo Docker installed, updating apt...

sudo ./apt-update.sh
