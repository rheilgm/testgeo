docker
======

CentOS/RHEL/Fedora containers do not have native support for AUFS, thus containers are limited by default to 10GB.  Read more here for reconfiguration: http://jpetazzo.github.io/2014/01/29/docker-device-mapper-resize/

/bin - Bash/python scripts used to build, start and destroy a geomesa "psudeo-cloud" instance. (HDFS + Accumulo + Zk + Geoserver)

* accumulo-shell.sh   Attaches to the Bourne Again SHell running inside the Accumulo container.
* bounce-accumulo-container.sh    Restarts the Accumulo container.
* build-and-deploy.sh Builds Geomesa, Rebuilds all containers and runs them linked displaying info after.
* cleanup-docker.sh   Remove dangling containers and source images from failed Dockerfile builds.
* deploy.sh           Runs containers linked and displays info after.
* destroy-geomesa.sh  Stops and Removes the current instance running. Just the containers, NOT images.
* docker_api.py       Python Script using docker-py to start containers linked
* geomesa_info.py     Python Script using docker-py to pretty print container info for geomesa.
* rebuild-and-deploy-geoserver.sh   Rebuilds and deploys Geoserver w/ Geomesa Plugin, re-linking to the parent containers.

/conf - custom configurations will go here as implemented.

* accumulo.conf   Settings for the accumulo container.
* geomesa.conf    Settings for the geomesa build.
* geoserver.conf  Settings for the geoserver container.

/sbin - Bash/python scripts requiring sudo

* apt-update.sh   Updates the base Ubuntu 14.04 image's apt cache and installs needed packages for geomesa-docker.
* docker_net.py   Experimental.  Used to create a Virtual interface on the LAN and bind docker ports to that IP. Avoids port conflicts with host.
* format-docker.sh    Deletes EVERYTHING from your system related to docker images, containers and logs.  Bounces the service.
* install-docker.sh   Installs the needed kernel-extras and docker PPA with packages.  Also updates apt-cache for ubuntu image.
* setup-mvn.sh    Installs maven on host.

docker-cloud-init.script - Cloud-init script for installing Docker and Docker-py on Openstack or other AWS type platform.