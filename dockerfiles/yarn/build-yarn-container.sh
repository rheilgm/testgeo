#!/bin/bash
cd "$(dirname "$0")"
source ../../conf/accumulo.conf


STARTTIME=$(date +%s)

if [ ! -f /tmp/jdk-7u67-linux-x64.tar.gz ]
    then
    wget -P /tmp --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" $JDK_DOWNLOAD_LINK
fi

if [ ! -f /tmp/hadoop-2.2.0.tar.gz ]
    then
    wget -P /tmp $HADOOP_DOWNLOAD_LINK
fi

echo "Building..."

# tar the files, run the build, cleanup afterwards by removing the artifacts.
tar -cvf build-files.tar -T files.txt
docker build -t user:yarn .
rm build-files.tar
ENDTIME=$(date +%s)
echo "It took $[$ENDTIME - $STARTTIME] seconds to complete this task..."
