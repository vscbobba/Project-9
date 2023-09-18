#!/bin/bash
sudo apt update
sudo apt install openjdk-11-jdk -y
sudo apt install maven -y
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
/usr/share/keyrings/jenkins-keyring.asc > /dev/null
  
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
/etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt-get update
apt-get install jenkins -y
/usr/lib/jenkins/jenkins-plugin-cli -f "github:latest"
echo 'ClientAliveInterval 60' | sudo tee --append /etc/ssh/sshd_config
sudo sed -i 's/^StrictHostKeyChecking.*/StrictHostKeyChecking no/' /etc/ssh/ssh_config
sudo service ssh restart

sudo apt-get remove docker docker-engine docker.io containerd runc
sudo apt update -y
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-cache policy docker-ce
sudo apt install docker-ce -y
sudo chmod 777 /var/run/docker.sock
sudo docker run -d --name mysonar -p 9000:9000 -p 9092:9092 sonarqube
docker update --restart always mysonar
docker run -d -p 8081:8081 --name nexus sonatype/nexus3
docker update --restart always nexusvenkat@BOBBASCLOUD