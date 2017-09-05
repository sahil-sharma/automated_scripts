#!/bin/bash
set -e
echo -e "\n" "Getting IP's of all the instance. Please wait..."
echo ""
master=`vagrant ssh master -c "hostname -I | cut -d' ' -f2" 2>/dev/null`
slave1=`vagrant ssh slave1 -c "hostname -I | cut -d' ' -f2" 2>/dev/null`
slave2=`vagrant ssh slave2 -c "hostname -I | cut -d' ' -f2" 2>/dev/null`
nginx=`vagrant ssh nginx -c "hostname -I | cut -d' ' -f2" 2>/dev/null`

#echo ""
echo "Master IP: " $master
echo "Slave1 IP: " $slave1
echo "Slave2 IP: " $slave2
echo "Nginx IP: " $nginx
echo ""
echo -e "Everything looks good to me." "\n"
echo -e "Please wait logging into master instance"
sleep 5
echo ""
ssh -i ./machine-keys/server -o "StrictHostKeyChecking no" ghost@$master

