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
sudo service sshd restart

sudo apt-get remove docker docker-engine docker.io containerd runc
sudo apt update -y
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-cache policy docker-ce
sudo apt install docker-ce -y
sudo chmod 777 /var/run/docker.sock
sudo apt install python3-pip -y
sudo pip install docker-py
usermod -a -G docker ansadmin