#!/bin/bash
cd "$(dirname "$0")"
STARTTIME=$(date +%s)

# rebuild images from repos
../dockerfiles/accumulo/build-accumulo-container.sh
../dockerfiles/geomesa/build-geoserver-container.sh
../dockerfiles/yarn/build-yarn-container.sh

# launch instances and link
./docker_api.py
ENDTIME=$(date +%s)
echo "It took $[$ENDTIME - $STARTTIME] seconds to complete this task..."
