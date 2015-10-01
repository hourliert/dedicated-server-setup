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

# mailserver
You SHOULD add ssl certificates into `roles/docker.mailserver/files/ssl` to enable ssl on the mail server.
Follow instructions on https://github.com/tomav/docker-mailserver to do it.

If adding a mailbox (imap folder) (in mail on OS X for instance) doesn't work. 
Go in the docker container in `/var/mail/tld/account` and create a file `courierimapsubscribed` with in it:
```
INBOX.Drafts
INBOX.Sent
INBOX.Trash
```
and execute
```
maildirmake .Drafts
maildirmake .Trash
maildirmake .Sent
```
