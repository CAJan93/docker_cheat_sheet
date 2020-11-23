# default arguments, specifying software version and similar things
ARG GO_VERSION=1.15.5
ARG GOCODE_DIR=/root/gocode
ARG LINUX=amd64
ARG STERN_VERSION=1.11.0
# folder that contains run_docker_pretty.sh
ARG START_DIR=/root/start
ARG UBUNTU_VERSION=20.10

FROM ubuntu:${UBUNTU_VERSION} AS base
ARG GO_VERSION
ARG GOCODE_DIR
ARG LINUX

# setup environment for golang
WORKDIR ${GOCODE_DIR}
ENV PATH=$PATH:/usr/local/go/bin
ENV GOPATH=${GOCODE_DIR}
ENV PATH=$PATH:$GOPATH/bin

# install necessary tools and golang
RUN apt update && apt upgrade -y && apt install -y wget git && \
wget https://golang.org/dl/go${GO_VERSION}.linux-${LINUX}.tar.gz && \
tar -C /usr/local -xzf go${GO_VERSION}.linux-${LINUX}.tar.gz && \
rm go${GO_VERSION}.linux-${LINUX}.tar.gz 


FROM base AS dockerpretty
ARG GOCODE_DIR
ARG START_DIR

# install dockerfmts
WORKDIR ${GOCODE_DIR}
RUN go get github.com/jessfraz/dockfmt

WORKDIR ${START_DIR}
COPY run_docker_pretty.sh run_docker_pretty.sh
RUN chmod +x run_docker_pretty.sh

ENTRYPOINT [ "./run_docker_pretty.sh" ]


FROM base AS bashpretty
ARG START_DIR

# install beautysh
RUN apt install -y pip && \
    pip install beautysh
    
WORKDIR ${START_DIR}
COPY run_bash_pretty.sh run_bash_pretty.sh
RUN chmod +x run_bash_pretty.sh

ENTRYPOINT [ "./run_bash_pretty.sh" ]
