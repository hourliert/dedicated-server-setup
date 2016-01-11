FROM golang:latest

RUN groupadd docker -g 999
RUN groupadd webhook -g 8888
RUN useradd -d "{{webhook_data}}" -s /bin/bash -u 8888 -g 8888 webhook
RUN usermod -a -G docker webhook

ADD docker-compose.sh /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose

RUN go get github.com/adnanh/webhook

WORKDIR {{webhook_data}}

USER webhook

CMD webhook -hooks ./config.json -verbose -hotreload -urlprefix ''
