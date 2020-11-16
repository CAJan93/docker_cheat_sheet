# File shows different ways of copying
#
# Usage:
#           Build hello-world stage with the binary from qorbani/golang-hello-world using DOCKER_BUILDKIT=1 docker build --tag copy:hw --target hw --file copy.dockerfile .
#           Run hello-world stage with docker run -d -p 80:80 -e PORT=80 --name=my-hello-world copy:hw
#           observe output in localhost:80
#
#           Build a hello-world from a local source file using DOCKER_BUILDKIT=1 docker build --tag copy:hw-local --target hw-local --file copy.dockerfile .
#           RUN hello-world-local stage with docker run --name=my-hello-world copy:hw-local
#           Observe output in terminal
#
#           Build a hello-world from remote github source file using DOCKER_BUILDKIT=1 docker build --tag copy:hw-github --target hw-github --file copy.dockerfile .
#           Run hello-wold-github stage with docker run --rm copy:hw-github
#           Observe output in terminal

# global arguments have to be repeated in each stage
ARG HELLO_WORLD_DIR=/hwd/
ARG HELLO_WORLD_COMMIT=ba5f437

# Copy parts of an existing image
FROM golang:alpine AS hw
ARG HELLO_WORLD_DIR

WORKDIR ${HELLO_WORLD_DIR}
COPY --from=qorbani/golang-hello-world /app/hello-world hello-world
CMD ["/hwd/hello-world"]


# Copy from local source
FROM golang:alpine AS hw-local
ARG HELLO_WORLD_DIR

WORKDIR ${HELLO_WORLD_DIR}
ADD example-src/main.go main.go
RUN go build main.go && \
    rm main.go && \
    mv main hello-world
CMD ["/hwd/hello-world"]    


# Copy from remote github
FROM golang:alpine AS hw-github
ARG HELLO_WORLD_DIR
ARG HELLO_WORLD_COMMIT

# install wget to pull a specific file from github
RUN apk update && apk upgrade && \
    apk add --no-cache wget

# specify commit id using HELLO_WORLD_COMMIT
WORKDIR ${HELLO_WORLD_DIR}-src
RUN wget https://raw.githubusercontent.com/go-training/helloworld/${HELLO_WORLD_COMMIT}/main.go && \
    go build main.go

# remove src
WORKDIR ${HELLO_WORLD_DIR}
RUN cp ${HELLO_WORLD_DIR}-src/main hello-world && \
    rm -rf ${HELLO_WORLD_DIR}-src/
CMD ["/hwd/hello-world"]