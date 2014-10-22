#!/bin/bash
read -p "This will delete all docker images, containers and log files. Are you sure? [y/n]: " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
    # do dangerous stuff
    sudo service docker stop
    sudo rm -Rf /var/lib/docker
    sudo service docker start
fi
