#!/bin/bash

. ../scripts/uri-parser.sh


echo "Ready to rock"
git_url=$1
deploy_key=`echo -n $2 | base64 -d`
registry=$3
registry_login=$4
registry_password=$5
registry_email=$6
project_name=$7
random_id=$[ 1 + $[ RANDOM % 10000000 ]]

if [ -z "$git_url" ]; then exit 1; fi
if [ -z "$deploy_key" ]; then exit 1; fi
if [ -z "$registry" ]; then exit 1; fi
if [ -z "$registry_login" ]; then exit 1; fi
if [ -z "$registry_password" ]; then exit 1; fi
if [ -z "$registry_email" ]; then exit 1; fi
if [ -z "$project_name" ]; then exit 1; fi


echo "Parsing arguments"
uri_parser "$git_url" || { echo "Malformed Git URL!"; exit 2; }
registry_host=$(basename $registry)


echo "Setup SSH"
# ssh config
mkdir -p ~/.ssh
echo "$deploy_key" >> ~/.ssh/id_rsa
chmod 400 ~/.ssh/id_rsa
cat >> ~/.ssh/config <<EOF
Host ${uri_host}
    HostName ${uri_host}
    User ${uri_user}
    IdentitiesOnly yes
    Port ${uri_port}
    IdentityFile ~/.ssh/id_rsa
EOF
ssh-keyscan -p $uri_port -H $uri_host >> ~/.ssh/known_hosts
cat ~/.ssh/known_hosts


echo "Cloning"
git clone $1 "project${random_id}"


echo "Setup Docker Registry"
docker login -e "$registry_email" -u "$registry_login" -p "$registry_password" "$registry"


echo "Running"
cd "./project${random_id}"
docker-compose -p "$project_name" up -d


echo "Cleaning"
docker logout "$registry"
cd ..
rm -rf "project${random_id}"
rm -rf ~/.ssh

