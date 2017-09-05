#!/bin/bash
set -e

# Checking distro type
distro_type=`sed -n -e '/PRETTY_NAME/ s/^.*=\|"\| .*//gp' /etc/os-release`
echo "-----------------------"
echo "Distro identified is: " $distro_type
echo "-----------------------"

vagrant_version=`vagrant --version`
virtualbox_version=`vboxmanage -version`
echo -e "Detecting Virtualbox and Vagrant version..." "\n"
sleep 3
echo "-----------------------"
echo -e "Virtualbox installed version is: " $virtualbox_version "\n"
echo -e "Vagrant installed version is: " $vagrant_version
echo "-----------------------"
echo ""
sleep 3

interface=`route | grep '^default' | grep -o '[^ ]*$'`
my_default_bridge=${interface%%$'\n'*}

OPTIONS="Single-Master-Cluster Multi-Master-Cluster"
echo ""
echo -e "Choose your option:\n"
select opt in $OPTIONS; do
	if [ "$opt" == "Single-Master-Cluster" ]; then
		#Single master
		echo -e "Creating single master cluster" "\n"
		cd $(pwd)/single-master
		echo -e "It will take time. It will create 4 vagrant machines of CentOS7 with 1GB RAM."
		echo -e "1 Master and 2 Slaves and 1 Nginx" "\n"
		sleep 10
		MY_IP=$my_default_bridge vagrant up
		./ip.sh
		echo "######################"
	elif [ "$opt" == "Multi-Master-Cluster" ]; then
		#Multi master cluster
		echo -e "Creating multi-master cluster" "\n"
		cd multi-master
		echo -e "It will take time. It will create 7 vagrant machines with 1GB RAM."
		echo -e "3 Masters and 3 Slaves and 1 Nginx instance" "\n"
		sleep 10
		vagrant up
		./ip.sh
		echo "######################"
	else
		clear
		echo "Wrong option selected"
		exit
	fi
done
set +e
