#this is the base image we use to create our image from
FROM jenkins/jenkins:2.201-slim

USER root
RUN apt-get update -qq \
    && apt-get install -qqy apt-transport-https ca-certificates curl gnupg2 software-properties-common 

RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
RUN add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"

RUN apt-get update  -qq \
    && apt-get install docker-ce=17.12.1~ce-0~debian -y
RUN usermod -aG docker jenkins

#just info about who created this
MAINTAINER Deepjyoti Borah (depborah86@gmail.com)

#get rid of admin password setup
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"

#Automatically install all plugins
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
# RUN apt-get update && \
#       apt-get -y install sudo
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt
COPY config.xml /usr/share/jenkins/ref/jobs/seed/config.xml

RUN apt-get -y install sshpass

#Install Ansible
RUN apt update
RUN apt install software-properties-common
RUN apt-add-repository ppa:ansible/ansible
RUN apt -y install ansible

RUN export ANSIBLE_HOST_KEY_CHECKING=False