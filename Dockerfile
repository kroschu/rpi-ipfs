#dockerfile for rpi-ipfs
#builds a Raspberry Pi compatible Docker image that when run creates an IPFS Node

FROM hypriot/rpi-alpine-scratch
MAINTAINER @kroschu
ENV IPFS_PATH /data/ipfs
ENV VERSION v0.4.
EXPOSE 4001 5001 8080
VOLUME /data/ipfs
ADD https://raw.githubusercontent.com/kroschu/rpi-ipfs/master/container_daemon /usr/local/bin/start_ipfs
RUN apk update \
 && apk upgrade \
 && apk add --update bash curl wget ca-certificates tar \
 && mkdir -p /data/ipfs \
 && wget https://dist.ipfs.io/go-ipfs/${VERSION}/go-ipfs_${VERSION}_linux-arm.tar.gz  \
 && tar -xzf  go-ipfs_${VERSION}_linux-arm.tar.gz \
 && rm go-ipfs_${VERSION}_linux-arm.tar.gz \
 && mv go-ipfs/ipfs /usr/local/bin/ipfs \
 && chmod 755 /usr/local/bin/start_ipfs \
 && apk del wget \
 && apk del tar \
 && apk del curl \
 && rm -rf /var/cache/apk/*
ENTRYPOINT ["/bin/bash", "/usr/local/bin/start_ipfs"]
