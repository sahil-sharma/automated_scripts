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

#Loading vagrant box
echo -e "Deleting previous FCCentOS7 box if present."
sleep 3
vagrant box remove FCCentOS7 --force || true
echo -e "Loading FCCentOS7 vagrant box... Please wait..." "\n"
cd vagrant-box
vagrant box add --name FCCentOS7 CentOS-7-x86_64-Vagrant-1706_02.VirtualBox.box
sleep 3
cd ..

interface=`route | grep '^default' | grep -o '[^ ]*$'`
my_default_bridge=${interface%%$'\n'*}

#read -p "Enter the RAM size (in MBs): " ram
#read -p "Enter cores: " cores

OPTIONS="Single-Master-Kubernetes-Cluster Multi-Master-Kubernetes-Cluster"
echo ""
echo -e "Choose your option:\n"
select opt in $OPTIONS; do
	if [ "$opt" == "Single-Master-Kubernetes-Cluster" ]; then
		#Single master
		echo -e "Creating single master kubernetes cluster" "\n"
		cd $(pwd)/single-master
		echo -e "It will take time. It will create 3 vagrant machines of CentOS7 with 1GB RAM."
		echo -e "1 Master and 2 Slaves" "\n"
		sleep 10
		MY_IP=$my_default_bridge vagrant up
		./ip.sh
		echo "######################"
		#echo -e "Creating kubernetes single master cluster" "\n"
		#ssh -t -i ./single-master/machine-keys/server formcept@172.21.2.11 <<-EOF
		#cp /vagrant/create-k8cluster.sh ~
		#./create-k8cluster.sh
		#EOF
		#vagrant ssh master
	elif [ "$opt" == "Multi-Master-Kubernetes-Cluster" ]; then
		#Multi master cluster
		echo -e "Creating multi master kubernetes cluster" "\n"
		cd multi-master
		echo -e "It will take time. It will create 7 vagrant machines with 1GB RAM."
		echo -e "3 Masters and 3 Slaves and 1 Nginx instance" "\n"
		sleep 10
		vagrant up
		./ip.sh
		echo "######################"
		#echo -e "Creating kubernetes multi master cluster" "\n"
		#ssh -t -i ./multi-master/machine-keys/server formcept@172.21.1.11 <<-EOF
		#cp /vagrant/create-k8cluster.sh ~
		#./create-k8cluster.sh
		#EOF
		#vagrant ssh master1
	else
		clear
		echo "Wrong option selected"
		exit
	fi
done
set +e
