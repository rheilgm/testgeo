#!/bin/bash
cd "$(dirname "$0")"

echo "Cleaning up dangling containers and images from failed builds."
docker rm $(docker ps -aq -f dangling=true)
docker rmi $(docker images | grep "<none>" | awk '{print $3}')
echo "----INFO:  done. this script will simply show usage if there is nothing to clean"
