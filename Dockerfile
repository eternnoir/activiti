#
# Ubuntu 14.04 with activiti Dockerfile
#
# Pull base image.
FROM dockerfile/java
MAINTAINER Frank Wang "eternnoir@gmail.com"

EXPOSE 8080

ENV TOMCAT_VERSION 8.0.8
ENV ACTIVITI_VERSION 5.16.3

RUN wget http://archive.apache.org/dist/tomcat/tomcat-8/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz -O /tmp/catalina.tar.gz
RUN wget https://github.com/Activiti/Activiti/releases/download/activiti-${ACTIVITI_VERSION}/activiti-${ACTIVITI_VERSION}.zip -O /tmp/activiti.zip

# Unpack
RUN tar xzf /tmp/catalina.tar.gz -C /opt
RUN ln -s /opt/apache-tomcat-${TOMCAT_VERSION} /opt/tomcat
RUN rm /tmp/catalina.tar.gz

RUN unzip /tmp/activiti.zip -d /opt/activiti

# Add roles
ADD tomcat-users.xml /opt/apache-tomcat-${TOMCAT_VERSION}/conf/

# Remove unneeded apps
RUN rm -rf /opt/tomcat/webapps/examples
RUN rm -rf /opt/tomcat/webapps/docs

# cp activiti war
RUN cp /opt/activiti/activiti-${ACTIVITI_VERSION}/wars/* /opt/tomcat/webapps/

# Install MySql
#RUN apt-get update
#RUN DEBIAN_FRONTEND=noninteractive apt-get -y install mysql-server pwgen
# Remove pre-installed database
#RUN rm -rf /var/lib/mysql/*
#

CMD ["/opt/tomcat/bin/catalina.sh","run"]

