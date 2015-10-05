# dedicated-server-setup
Just a reminder on how to setup a dedicated server.

## Server
Dedibox XC 2015

## How 
Ansible & Docker.

`ansible-playbook deploy.yml -i inventories/hosts --ask-become-pass`


## Features
* Mail server https://github.com/tomav/docker-mailserver
* Owncloud https://github.com/jchaney/owncloud
* Gitlab https://github.com/sameersbn/docker-gitlab
* Gitlab CI (included in Gitlab since Gitlab 8)
* OpenVPN https://github.com/kylemanna/docker-openvpn
* Monitoring https://github.com/google/cadvisor
* Logging https://github.com/fluent/fluentd-docker-image
* Nginx reverse proxy https://github.com/jwilder/nginx-proxy
* Plex https://github.com/wernight/docker-plex-media-server
* PostgreSQL https://hub.docker.com/_/postgres/
* Redis https://hub.docker.com/_/redis/
* Torrent https://github.com/kfei/docktorrent

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

# cadvisor
The support is partial until https://github.com/google/cadvisor/issues/771 is resolved.
Actually, advisor can only informs user about system status and not docker containers status.
We can't mount -v /var/lib/docker/:/var/lib/docker:ro because when an other container restart, it crashes and marks the container as dead.

# fluentd
Fluentd works great. We need to launch every containers with the --log_driver=fluentd option. Ansible 1.9.x doesn't support this option yet. We need to wait for **2.0.0**.
Until that, fluentd is disable.

# openvpn
This contaier is also disable until **ansible 2.0.0** to have cap_add NET_ADMIN option.

At the first run, we need to run to generate ssh keys:
```
docker run -v "{{openvpn_data}}:/etc/openvpn" --rm kylemanna/openvpn ovpn_genconfig -u udp://{{openvpn_hostname}}
docker run -v "{{openvpn_data}}:/etc/openvpn" --rm -it kylemanna/openvpn ovpn_initpki
```
and to get client config
```
docker run -v "{{openvpn_data}}:/etc/openvpn" --rm -it kylemanna/openvpn easyrsa build-client-full {{client_name}} nopass`
docker run -v "{{openvpn_data}}:/etc/openvpn" --rm kylemanna/openvpn ovpn_getclient {{client_name}} > {{client_name}}.ovpn
```

# plex
At the first run.

* Create a ssh tunel between localhost and the server: `ssh -L 32400:localhost:32400 -N thomashourlier@cnode.fr`
* loging to http://localhost:32400/web, check remote access
* restart plex container
* recheck remote acces
* close tunel
