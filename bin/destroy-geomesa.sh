#!/bin/bash
cd "$(dirname "$0")"
echo "Stopping & Removing Docker-Geomesa containers..."
docker stop tests-accumulo tests-yarn tests-geoserver
docker rm tests-accumulo tests-yarn tests-geoserver
echo "DONE."