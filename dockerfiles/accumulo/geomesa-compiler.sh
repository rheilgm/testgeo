#!/bin/bash
cd "$(dirname "$0")"
mvn -T6 -DskipTests=true clean package
GEOMESAROOT=$(pwd)
tar xvfz ./geomesa-assemble/target/geomesa-1.0.0-SNAPSHOT-bin.tar.gz
. ./geomesa-1.0.0-SNAPSHOT/bin/geomesa configure
