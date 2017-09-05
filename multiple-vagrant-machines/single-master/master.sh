#!/bin/bash
set -e

yum update -y
yum install epel-release -y
yum install ntp nano wget tree elinks bind-utils net-tools gcc make telnet firewalld -y
setenforce 0
iptables -L
systemctl stop firewalld.service
echo -e "Creating ghost user account\n"
useradd -m ghost -s /bin/bash
usermod -aG wheel ghost
echo "ghost:ghost" |chpasswd
echo 'ghost	ALL=(ALL:ALL) ALL' >> /etc/sudoers
echo 'ghost	ALL=(ALL:ALL) NOPASSWD: ALL' >> /etc/sudoers
mkdir -p /home/ghost/.ssh/ && cp /vagrant/machine-keys/* /home/ghost/.ssh/
chmod 0700 /home/ghost/.ssh/ && chmod 0600 /home/ghost/.ssh/*
chown -R ghost:ghost /home/ghost/.ssh/
cp -r /vagrant/kubedns /home/ghost/
cp -r /vagrant/nginx-1.7.6 /home/ghost/
chown -R ghost:ghost /home/ghost
