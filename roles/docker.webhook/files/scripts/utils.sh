#!/bin/bash

function lock {
  echo "Locking $lock_dir"
  while ! mkdir "$lock_dir"; do
    sleep 3
  done
}

function unlock {
  echo "Unlocking $lock_dir"
  rm -rf "$lock_dir"
}

function setup_ssh {
  # ssh config
  mkdir -p ~/.ssh
  echo "$deploy_key" > "${HOME}/.ssh/id_rsa_${random_id}"
  chmod 400 "${HOME}/.ssh/id_rsa_${random_id}"
cat >> ~/.ssh/config <<EOF
Host project${random_id}
    HostName ${uri_host}
    User ${uri_user}
    IdentitiesOnly yes
    Port ${uri_port}
    IdentityFile ~/.ssh/id_rsa_${random_id}
EOF
  ssh-keyscan -p $uri_port $uri_host >> ~/.ssh/known_hosts
}

function clean {
  cd ..
  rm -rf "project${random_id}"
  rm -rf "${HOME}/.ssh/id_rsa_${random_id}"
  sed -e "/Host\sproject${random_id}/,+5d" ~/.ssh/config > ~/.ssh/config
}
