#!/bin/bash
cd "$(dirname "$0")"
../dockerfiles/geomesa/build-geoserver-container.sh
docker stop tests-geoserver; docker rm tests-geoserver
docker run -Pit -h geoserver --name tests-geoserver --link tests-accumulo:accumulo --link tests-yarn:yarn user:geoserver
