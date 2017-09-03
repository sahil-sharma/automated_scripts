#!/bin/bash
set -e
echo -e "\n"
echo -e "If the AWS instance is Ubuntu then the username is ubuntu\n"
echo -e "If the AWS instance is CentOS then the username is centos\n"

read -p 'Enter IP: ' remote_ip
read -p 'Enter username: ' remote_uname
read -p 'Enter SSH key file location (you can leave it if you have the password): ' sshkey_location

echo -e "Choose your option:\n"

echo "*******************"

OPTIONS="SSH Port-Mapping Copyfiles-Remote-to-Local Copyfiles-Local-to-Remote"

select opt in $OPTIONS; do
	if [ "$opt" == "SSH" ]; then
		if [[ -z "$sshkey_location" ]]; then
			echo "SSH into the machine without SSH key"
			ssh $remote_uname@$remote_ip
			exit
		else
                        echo "SSH into the machine"
			ssh -i $sshkey_location $remote_uname@$remote_ip
		exit
		fi

	elif [ "$opt" == "Port-Mapping" ]; then
		echo "Mapping the port of remte machine to your local mahine"
		read -p 'Enter remote machine port: ' remote_port
		read -p 'Enter local machine port: ' local_port
		ssh -i $sshkey_location -L $local_port:localhost:$remote_port $remote_uname@$remote_ip
		exit

	elif [ "$opt" == "Copyfiles-Remote-to-Local" ]; then
		echo "Copying files from remote machine to your local machine"
		read -p "Enter remote file location: " remote_file_location
		read -p "Enter local location: " local_file_location
		scp -i $sshkey_location $remote_uname@$remote_ip:$remote_file_location $local_file_location
		exit

	elif [ "$opt" == "Copyfiles-Local-to-Remote" ]; then
		echo "Copying files from your local machine to remote machine"
		read -p "Enter remote location: " remote_file_location
		read -p "Enter local file location: " local_file_location
		scp -i $sshkey_location $local_file_location $remote_uname@$remote_ip:$remote_file_location
		exit
	else
		clear
		echo "Wrong option selected"
		exit
	fi
done
set +e
