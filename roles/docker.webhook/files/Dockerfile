FROM golang:latest

RUN go get github.com/adnanh/webhook

WORKDIR /webhook

CMD webhook -hooks ./config.json -verbose -hotreload -urlprefix ''
