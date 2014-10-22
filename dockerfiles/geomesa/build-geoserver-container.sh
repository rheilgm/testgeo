#!/bin/bash
cd "$(dirname "$0")"
STARTTIME=$(date +%s)
source ../../conf/geoserver.conf
source ../../conf/geomesa.conf

if [ ! -f /tmp/jdk-7u67-linux-x64.tar.gz ]
    then
    wget -P /tmp --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/7u67-b01/jdk-7u67-linux-x64.tar.gz
fi


if [ ! -f /tmp/geoserver-2.5.2-bin.zip ]
    then
    wget -P /tmp $GEOSERVER_DOWNLOAD_LINK
fi

if [ ! -f /tmp/geoserver-2.5.2-wps-plugin.zip ]
    then
    wget -P /tmp $WPS_DOWNLOAD_LINK
fi

echo "Building..."
mvn -T6 clean package


cp $GEOMESA_BUILD_PATH/geomesa/geomesa-plugin/target/$GEOMESA_PLUGIN_JAR ./geomesa-plugin.jar
cp $GEOMESA_BUILD_PATH/geomesa/geomesa-core/target/$GEOMESA_CORE_JAR ./geomesa-core.jar


# geoserver wps plugin
unzip -d ./deps -o /tmp/geoserver-2.5.2-wps-plugin.zip

tar -cvf build-files.tar -T files.txt
docker build -t user:geoserver .
# docker build -t user:geoserver --no-cache=true .
rm -Rf build-files.tar *.jar ./deps ./target
ENDTIME=$(date +%s)
echo "It took $[$ENDTIME - $STARTTIME] seconds to complete this task..."
