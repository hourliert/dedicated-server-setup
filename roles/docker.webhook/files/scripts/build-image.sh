#!/bin/bash

git_url=$1
deploy_key=`echo -n $2 | base64 -d`

echo "Setup"
# ssh config
mkdir -p ~/.ssh
echo "$deploy_key" >> ~/.ssh/id_rsa
chmod 400 ~/.ssh/id_rsa
cat >> ~/.ssh/config <<EOF
Host git.wid.la
    HostName git.wid.la
    User git
    IdentitiesOnly yes
    Port 10022
    IdentityFile ~/.ssh/id_rsa
EOF
ssh-keyscan -p 10022 -H git.wid.la >> ~/.ssh/known_hosts
cat ~/.ssh/known_hosts

echo "Cloning"
git clone $1 "project"

echo "Building"
cd ./project
docker build -t tmp-image .
docker login -e 'build@git.wid.la' -u 'thomas' -p '123456' registry.wid.la:5000

docker tag tmp-image registry.wid.la:5000/tmp-image:latest
docker push -f registry.wid.la:5000/tmp-image:latest


echo "Cleaning"
docker logout registry.wid.la:5000
docker rmi tmp-image
# clean ssh
rm -rf ~/.ssh

# clean tmp
cd ..
rm -rf *

