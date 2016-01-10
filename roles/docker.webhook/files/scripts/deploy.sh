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
git clone $1

echo "Building"
cd ./versatile-react
docker build -t versatile-image .
docker rm -f versatile

echo "Running"
docker run --name versatile -p 5000 -e "VIRTUAL_HOST=versatile.cnode.fr" versatile-image

echo "Cleaning"
# clean ssh
rm -rf ~/.ssh

# clean tmp
cd ..
rm -rf *

