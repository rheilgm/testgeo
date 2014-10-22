#
# geomesa
#

FROM ubuntu:14.04
MAINTAINER charles.ott@ccri.com
#RUN apt-get update
#RUN apt-get -y install tar unzip ssh nano python-yaml

# Add all files at once
ADD build-files.tar /root/

RUN mkdir /opt/java
RUN mkdir /var/run/sshd
RUN tar -C /opt/java -xzf /root/tmp/jdk-7u67-linux-x64.tar.gz

ENV JAVA_HOME /opt/java/jdk1.7.0_67
ENV PATH $PATH:$JAVA_HOME/bin
RUN unzip -d /opt/ /root/tmp/geoserver-2.5.2-bin.zip
ENV GEOSERVER_HOME /opt/geoserver-2.5.2/
RUN chmod -R 777 /opt/geoserver-2.5.2

# Deps go here: /opt/geoserver-2.5.2/webapps/geoserver/WEB-INF/lib/
RUN mv /root/deps/*.jar /opt/geoserver-2.5.2/webapps/geoserver/WEB-INF/lib/
RUN mv /root/geomesa-plugin.jar /opt/geoserver-2.5.2/webapps/geoserver/WEB-INF/lib/
RUN mv /root/geomesa-core.jar /opt/geoserver-2.5.2/webapps/geoserver/WEB-INF/lib/

EXPOSE 8080 22
ADD start-geoserver.sh /opt/start-geoserver.sh
CMD ["/opt/start-geoserver.sh"]
