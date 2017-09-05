#!/bin/bash
set -e

# Checking distro type
distro_type=`sed -n -e '/PRETTY_NAME/ s/^.*=\|"\| .*//gp' /etc/os-release`
echo "-----------------------"
echo "Distro identified is: " $distro_type
echo "-----------------------"
sleep 3

if [[ $distro_type == "Ubuntu" ]]; then
	echo "---------------------------------"
	echo -e "Installing Virtualbox-5.0" "\n"
	echo "---------------------------------"
	sh -c 'echo "deb http://download.virtualbox.org/virtualbox/debian $(lsb_release -cs) contrib" >> /etc/apt/sources.list.d/virtualbox.list'
	wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | apt-key add -
	apt-get update
	apt-get install virtualbox-5.0 -y
	echo "---------------------------------"
	echo -e "Installing Vagrant-1.9"
	sleep 5
	wget https://releases.hashicorp.com/vagrant/1.9.8/vagrant_1.9.8_x86_64.deb
	dpkg -i vagrant_1.9.8_x86_64.deb
	echo "---------------------------------"
	echo "Installing required plug-ins"
	vagrant plugin install vagrant-vbguest
	vagrant plugin update vagrant-vbguest
	vagrant plugin install vagrant-triggers
	echo "Restarting vagrant services..."
	service vboxdrv restart
	echo "---------------------------------"
	echo -e "Vagrant and Virtualbox has been installed."

elif [[ $distro_type == "CentOS" ]]; then
	echo "---------------------------------"
	echo -e "Installing system dependencies"
	yum -y install epel-release wget nano links tree gcc dkms make qt libgomp patch 
	yum -y install kernel-headers kernel-devel binutils glibc-headers glibc-devel font-forge
	yum install -y VirtualBox-5.1
	/sbin/rcvboxdrv setup
	echo -e "Install vagrant-1.9.8"
	yum -y install https://releases.hashicorp.com/vagrant/1.9.8/vagrant_1.9.8_x86_64.rpm
	echo "Installing required plug-ins"
	vagrant plugin install vagrant-vbguest
	vagrant plugin update vagrant-vbguest
	vagrant plugin install vagrant-triggers
	echo "---------------------------------"
	echo -e "Vagrant and Virtualbox has been installed."
else
	echo -e "Distro not indentified"
fi

set +e