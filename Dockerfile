FROM alpine:3.7
MAINTAINER Faisal Chaudhry <chaudhryfaisal@gmail.com>

ARG K8_VERSION=v1.9.0
ENV GOPATH="/usr/bin"
ENV GOROOT="/usr/lib/go"

RUN apk --update --no-cache add docker sudo bash && \
apk upgrade --update && \
apk add --no-cache --virtual=.build-dependencies ca-certificates python2 curl go make \
autoconf findutils make pkgconf libtool g++ automake linux-headers git && \
curl -Lo /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && \
mkdir -p /usr/bin/src/k8s.io && cd /usr/bin/src/k8s.io && chmod +x /usr/local/bin/kubectl && \
git clone https://github.com/kubernetes/minikube && cd minikube && \
make && mv ./out/minikube /usr/local/bin/minikube && rm -rf /usr/bin/src/k8s.io && rm -rf /tmp/* && \
minikube start --vm-driver none --kubernetes-version $K8_VERSION -v 7 --memory 1024 --disk-size 4g && \
apk del .build-dependencies
ADD ./dockerd-entrypoint.sh /usr/local/bin/
ADD ./dockerd-cmd.sh /usr/local/bin/
ADD ./setup-compose /usr/local/bin/
RUN chmod +x /usr/local/bin/*

EXPOSE 2375 30000
ENTRYPOINT ["dockerd-entrypoint.sh"]
CMD ["dockerd-cmd.sh"]
