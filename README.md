# dedicated-server-setup
Just a reminder on how to setup a dedicated server.

## Server
Dedibox XC 2015

## How 
Ansible & Docker.

`ansible-playbook deploy.yml -i hosts --ask-become-pass`


## Features
* Mail server https://github.com/tomav/docker-mailserver
* Owncloud https://hub.docker.com/_/owncloud/ 
* Gitlab https://github.com/sameersbn/docker-gitlab
* Gitlab CI https://github.com/sameersbn/docker-gitlab-ci and https://github.com/sameersbn/docker-gitlab-ci-runner
