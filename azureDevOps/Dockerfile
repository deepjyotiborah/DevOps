#this is the base image we use to create our image from
FROM jenkins/jenkins:2.201-alpine

#just info about who created this
MAINTAINER Deepjyoti Borah (depborah86@gmail.com)

#get rid of admin password setup
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"

#Automatically install all plugins
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN apt-get update && \
      apt-get -y install sudo
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt
