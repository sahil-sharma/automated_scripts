Download registry-setup.sh and run it:

$ ./registry-setup.sh

1) Once the script is executed it will install local docker registry on your machine at (:5000)
port.

You can check it:

$ docker ps -a |grep registry

2) Please copy the $domain.crt ($HOME/docker_registry/certs/$domain.crt) to your machine at:

/etc/docker/certs.d/<docker-regirsty-IP>/domain.crt

3) Add a file daemon.json at /etc/docker/ location with content as:

{"insecure-registries": ["<docker-regirsty-IP>:5000"]}

4) Restart docker daemon: /etc/init.d/docker restart

5) Check the set-up:

$ docker login https://docker-regirsty-IP:5000

e.g.: docker login https://192.168.1.111:5000

Enter username and password you entered in the script to login.

How to tag docker images:

docker tag <image-you-want-to-tag> <local-registry-IP:5000>/<image-name-of-your-choice>:<version>

$ docker tag ubuntu:16.04 192.168.1.111:5000/ubuntu:16.04

How to push an image to local docker registry:

$ docker push 192.168.1.111:5000/ubuntu:16.04

How to pull an image from local docker registry:

$ docker pull 192.168.1.111:5000/ubuntu:16.04
