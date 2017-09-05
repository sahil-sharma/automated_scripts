#!/bin/bash
set -e

yum update -y
yum install epel-release -y
yum install ntp nano wget tree elinks bind-utils net-tools telnet firewalld -y
systemctl start ntpd
systemctl stop firewalld
setenforce 0
iptables --flush
echo -e "Creating ghost user account\n"
useradd -m ghost -s /bin/bash
usermod -aG wheel ghost
echo "ghost:ghost" |chpasswd
echo 'ghost	ALL=(ALL:ALL) ALL' >> /etc/sudoers
echo 'ghost	ALL=(ALL:ALL) NOPASSWD: ALL' >> /etc/sudoers
mkdir -p /home/ghost/.ssh/ && cp /vagrant/machine-keys/* /home/ghost/.ssh/
chmod 0700 /home/ghost/.ssh/ && chmod 0600 /home/ghost/.ssh/*
chown -R ghost:ghost /home/ghost/.ssh/
chown -R ghost:ghost /home/ghost
