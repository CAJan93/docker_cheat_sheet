# default arguments, specifying software version and similar things
ARG GO_VERSION=1.15.5
ARG GOCODE_DIR=/root/gocode
ARG LINUX_ARCH=amd64
# folder that contains run.sh
ARG START_DIR=/root/start
ARG UBUNTU_VERSION=20.10

FROM ubuntu:${UBUNTU_VERSION}
ARG GO_VERSION
ARG GOCODE_DIR
ARG LINUX_ARCH
ARG START_DIR

# setup environment for golang
WORKDIR ${GOCODE_DIR}
ENV PATH=$PATH:/usr/local/go/bin
ENV GOPATH=${GOCODE_DIR}
ENV PATH=$PATH:$GOPATH/bin

# install necessary tools and golang
RUN apt update && apt upgrade -y && apt install -y wget git && \
wget https://golang.org/dl/go${GO_VERSION}.linux-${LINUX_ARCH}.tar.gz && \
tar -C /usr/local -xzf go${GO_VERSION}.linux-${LINUX_ARCH}.tar.gz && \
rm go${GO_VERSION}.linux-${LINUX_ARCH}.tar.gz 

# test ouput
RUN go get github.com/jessfraz/dockfmt

WORKDIR ${START_DIR}
COPY run.sh run.sh
RUN chmod +x run.sh

ENTRYPOINT [ "./run.sh" ]