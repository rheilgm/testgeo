#!/bin/bash
cd "$(dirname "$0")"
source ../../conf/accumulo.conf
source ../../conf/geomesa.conf

STARTTIME=$(date +%s)

if [ ! -f /tmp/jdk-7u67-linux-x64.tar.gz ]
    then
    wget -P /tmp --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" $JDK_DOWNLOAD_LINK
fi

if [ ! -f /tmp/hadoop-2.2.0.tar.gz ]
    then
    wget -P /tmp $HADOOP_DOWNLOAD_LINK
fi

if [ ! -f /tmp/zookeeper-3.4.6.tar.gz ]
    then
    wget -P /tmp $ZK_DOWNLOAD_LINK
fi

if [ ! -f /tmp/accumulo-1.5.2-bin.tar.gz ]
    then
    wget -P /tmp $ACCUMULO_DOWNLOAD_LINK
fi

echo "Building..."

#If the Geomesa folder is not here, then we can assume it needs to be got with git
if [ ! -d $GEOMESA_BUILD_PATH/geomesa ]
    then
    cd $GEOMESA_BUILD_PATH
    git clone $GEOMESA_GIT_PATH
fi

#build the geomesa
mvn -T 6 -f $GEOMESA_BUILD_PATH/geomesa clean package -DskipTests=true

#copy the distributed runtime to the local path so it can be combined with the tarball
cp $GEOMESA_BUILD_PATH/geomesa/geomesa-distributed-runtime/target/$DIST_RUNTIME_JAR ./geomesa-distributed-runtime.jar

#slf4j fix (not shaded?)
cp $HOME/.m2/repository/log4j/log4j/1.2.17/log4j-1.2.17.jar ./
cp $HOME/.m2/repository/org/slf4j/slf4j-log4j12/1.7.5/slf4j-log4j12-1.7.5.jar ./

#geomesa tools
cp $GEOMESA_BUILD_PATH/geomesa/geomesa-assemble/target/$GEOMESA_TOOLS_TARGZ ./geomesa-tools.tar.gz

# tar the files, run the build, cleanup afterwards by removing the artifacts.
tar -cvf build-files.tar -T files.txt
docker build -t user:accumulo --no-cache=true .
rm *.tar *.tar.gz *.jar
ENDTIME=$(date +%s)
echo "It took $[$ENDTIME - $STARTTIME] seconds to complete this task..."
