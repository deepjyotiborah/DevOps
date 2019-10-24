#!/bin/bash

# install docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
apt-cache policy docker-ce
sudo apt-get install -y docker-ce
sudo systemctl status docker


# Pull latest container
sudo docker pull deepborah/resource-image:v2
 
# Setup local configuration folder
# Should already be in a jenkins folder when running this script.
export CONFIG_FOLDER=$PWD/jenkins
mkdir $CONFIG_FOLDER
chown 1000 $CONFIG_FOLDER
 
# Start container
#GID=`grep docker /etc/group`
#sudo docker run -d -p 8080:8080 -v -u $CONFIG_FOLDER:/var/jenkins_home:z --rm --name -u jenkins:$GID myjenkins deepborah/resource-image:v1
#sudo docker run -d -p 8080:8080 -v /var/run/docker.sock:/var/run/docker.sock -v $(which docker):/usr/bin/docker -v -u $CONFIG_FOLDER:/var/jenkins_home:z --rm --name myjenkins deepborah/resource-image:v1
sudo docker run -d -p 8080:8080 -p 50000:50000  -v /var/run/docker.sock:/var/run/docker.sock -v $CONFIG_FOLDER:/var/jenkins_home:z  deepborah/resource-image:v2

#Install Ansible
sudo apt install software-properties-common
sudo apt-add-repository --yes --update ppa:ansible/ansible
sudo apt install ansible