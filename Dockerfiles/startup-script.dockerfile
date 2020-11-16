# File shows how to start an existing application using a startup script. You only have to build once and can then change the script to your liking
#
# Usage:
#           Build startup image with DOCKER_BUILDKIT=1 docker build --tag startup --file startup-script.dockerfile .
#           To execute this image use docker run -v ${PWD}/example-src:/start startup /start/start.sh
#           Binary will be executed via /Dockerfiles/example-src/start.sh.
#           Changes in your local start.sh will be reflected at every docker run command. There is no need to rebuild the image after changing start.sh

# global variables
ARG HELLO_WORLD_DIR=/hwd/
ARG START_DIR=/start

# Copy from local source
FROM golang:alpine
ARG HELLO_WORLD_DIR

WORKDIR ${HELLO_WORLD_DIR}
ADD example-src/main.go main.go
RUN go build main.go && \
    rm main.go && \
    mv main hello-world

# run command line from START_DIR
WORKDIR ${START_DIR}
ENTRYPOINT [ "ash" ]