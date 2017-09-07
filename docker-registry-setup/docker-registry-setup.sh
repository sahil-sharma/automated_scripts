#!/bin/bash
set -e
echo
read -p "Enter docker registry username: " registry_username
echo
stty -echo
read -p "Enter docker registry password: " registry_password
stty echo
echo
echo
echo "You will be login to this docker local registry with above username and password"
echo
read -p "Enter docker registry location (Please provide absolute path): " registry_location
echo

#Required
read -p "Enter your CommonName/FQDN (could be IP): " domain
commonname=$domain

echo
echo -e "Updating system and installing dependencies" "\n"
sleep 3
apt-get update
apt-get install -y apt-transport-https ca-certificates
echo -e "Installing docker" "\n"
sleep 3
wget -qO- https://get.docker.com/ | sh
echo -e "Adding user to docker group" "\n"
sleep 3
usermod -aG docker $(whoami)
echo -e "Creating directories required for Local Docker Registry"
mkdir -p $registry_location/docker_registry/images
mkdir -p $registry_location/docker_registry/certs
mkdir -p $registry_location/docker_registry/auth
mkdir -p $registry_location/docker_registry/compose-file
echo
sleep 3
docker run --name docker_auth_container --entrypoint htpasswd registry:2 -Bbn $registry_username $registry_password > $registry_location/docker_registry/auth/htpasswd
echo -e "Removing auth docker container"
docker rm docker_auth_container
echo -e "Before we create docker regisrty certifcates. Please enter few details..."
echo

SSL_DIR=$registry_location/docker_registry/certs

if [ -z "$domain" ]; then
	echo "FQDN not present. Please enter."
	read -p "Enter your FQDN: " fqdn
fi

# A blank passphrase
PASSPHRASE=""

# Set our CSR variables
SUBJ="
C=
ST=
O=
localityName=
commonName=$domain
organizationalUnitName=
emailAddress=
"

# Generate our Private Key, CSR and Certificate
openssl genrsa -out "$SSL_DIR/$domain.key" 2048

openssl req -new -subj "$(echo -n "$SUBJ" | tr "\n" "/")" -key "$SSL_DIR/$domain.key" -out "$SSL_DIR/$domain.csr" -passin pass:$PASSPHRASE

openssl x509 -req -days 365 -in "$SSL_DIR/$domain.csr" -signkey "$SSL_DIR/$domain.key" -out "$SSL_DIR/$domain.crt"

#Creating docker regisrty container
echo -e "Creating a local docker registry container"
docker run -d --name registry \
-p 5000:5000 \
-e REGISTRY_HTTP_TLS_CERTIFICATE:/certs/domain.crt \
-e REGISTRY_HTTP_TLS_KEY:/certs/domain.key \
-e REGISTRY_AUTH:htpasswd \
-e REGISTRY_AUTH_HTPASSWD_REALM:Registry*Realm \
-e REGISTRY_AUTH_HTPASSWD_PATH:/auth/htpasswd \
-v $registry_location/docker_registry/images:/var/lib/registry \
-v $registry_location/docker_registry/certs:/certs \
-v $registry_location/docker_registry/auth:/auth \
registry:2
cat $registry_location/docker_registry/certs/$domain.crt
echo
echo "---------------------------"
echo -e "-----\e[31mPay ATTENTION\e[0m-----"
echo "---------------------------"
echo
echo -e "\e[31mDocker registry has been set-up and runnning\e[0m" "\n"
echo -e "\e[31mPlease copy the $domain.crt to your machine at /etc/docker/certs.d/<docker-regirsty-IP>/domain.crt\e[0m" "\n"
echo -e "\e[31mYou can copy the $domain.crt from your presetn location\e[0m" "\n"
echo -e "\e[31mAlso add a file daemon.json at /etc/docker/ location with content as: \e[0m" "\n"
echo -e '\e[31m{"insecure-registries": ["<docker-regirsty-IP>:5000"]}\e[0m' "\n"
echo -e "\e[31mRestart docker daemon: /etc/init.d/docker restart\e[0m" "\n"
echo "---------------------------"
sleep 15