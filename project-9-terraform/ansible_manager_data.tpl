#!/bin/bash
yum update -y
sudo amazon-linux-extras install ansible2 -y
yum install openssh-server -y

sudo su -
# add the user ansadmin
useradd ansadmin
# set password
echo "ansadmin" | passwd --stdin ansadmin
# modify the sudoers file at /etc/sudoers and add entry
echo 'ansadmin     ALL=(ALL)      NOPASSWD: ALL' | sudo tee -a /etc/sudoers
echo 'ec2-user     ALL=(ALL)      NOPASSWD: ALL' | sudo tee -a /etc/sudoers
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sed -i 's/^StrictHostKeyChecking.*/StrictHostKeyChecking no/' /etc/ssh/ssh_config
echo 'ClientAliveInterval 60' | sudo tee --append /etc/ssh/sshd_config
sudo service sshd restart