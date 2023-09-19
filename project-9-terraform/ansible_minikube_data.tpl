#!/bin/bash
apt update -y
sudo su -
# add the user ansadmin
adduser ansadmin
# set password
#echo "ansadmin" | passwd --stdin ansadmin   #its not working
echo 'ansadmin:ansadmin' | sudo chpasswd
# modify the sudoers file at /etc/sudoers and add entry
echo 'ansadmin     ALL=(ALL)      NOPASSWD: ALL' | sudo tee -a /etc/sudoers
echo 'ubuntu     ALL=(ALL)      NOPASSWD: ALL' | sudo tee -a /etc/sudoers
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sed -i 's/^StrictHostKeyChecking.*/StrictHostKeyChecking no/' /etc/ssh/ssh_config
echo 'ClientAliveInterval 60' | sudo tee --append /etc/ssh/sshd_config
service sshd restart

apt-get remove docker docker-engine docker.io containerd runc
apt update -y
apt install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update && sudo apt-get install -y curl wget virtualbox
apt-cache policy docker-ce
apt install docker-ce -y
chmod 777 /var/run/docker.sock
apt install python3-pip -y
pip install docker-py
usermod -a -G docker ansadmin
apt-get update && sudo apt-get install -y apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
apt-get update
apt-get install -y kubectl
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
usermod -aG docker $USER && newgrp docker