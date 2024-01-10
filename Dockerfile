FROM alpine:latest as certs

RUN apk --update add ca-certificates

FROM gcr.io/kaniko-project/executor:v1.19.2-debug

SHELL ["/busybox/sh", "-c"]

RUN wget -O /crane.tar.gz \ 
    https://github.com/google/go-containerregistry/releases/download/v0.17.0/go-containerregistry_Linux_x86_64.tar.gz && \
    tar -xvzf /crane.tar.gz crane -C /kaniko && \
    rm /crane.tar.gz

COPY entrypoint.sh /
COPY --from=certs /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt

ENTRYPOINT ["/entrypoint.sh"]
