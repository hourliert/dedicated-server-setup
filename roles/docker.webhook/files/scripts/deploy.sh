#!/bin/bash

. ../scripts/uri-parser.sh
. ../scripts/utils.sh


echo "Ready to rock"
git_url=$1
deploy_key=`echo -n $2 | base64 -d`
registry=$3
registry_login=$4
registry_password=$5
registry_email=$6
project_name=$7
image_version=$8
random_id=$[ 1 + $[ RANDOM % 10000000 ]]
lock_dir="$HOME/docker.lock"

if [ -z "$git_url" ]; then exit 1; fi
if [ -z "$deploy_key" ]; then exit 1; fi
if [ -z "$registry" ]; then exit 1; fi
if [ -z "$registry_login" ]; then exit 1; fi
if [ -z "$registry_password" ]; then exit 1; fi
if [ -z "$registry_email" ]; then exit 1; fi
if [ -z "$project_name" ]; then exit 1; fi
if [ -z "$image_version" ]; then exit 1; fi


echo "Parsing arguments"
uri_parser "$git_url" || { echo "Malformed Git URL!"; exit 2; }
registry_host=$(basename $registry)


echo "Setup SSH"
setup_ssh


echo "Cloning"
git clone -b "$image_version" "${uri_schema}://project${random_id}${uri_path}" "project${random_id}"


echo "Setup Docker Registry"
lock
docker login -e "$registry_email" -u "$registry_login" -p "$registry_password" "$registry"


echo "Running"
cd "./project${random_id}"
docker-compose -p "$project_name" pull --ignore-pull-failures "$project_name"
docker-compose -p "$project_name" up -d "$project_name"


echo "Remove registry"
docker logout "$registry"
unlock


echo "Cleaning"
clean

