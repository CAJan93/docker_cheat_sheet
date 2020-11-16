# File shows how to multi-stage in order to support, build, release and testing stages
#
# Usage: 
#           Build the relase stage DOCKER_BUILDKIT=1 docker build --tag mygolangbins:release .
#           This release stage contains only the binaries from stage0 and stage1. The release stage is build by default.
#           If you want to explicitly build the release stage, you can do so via
#           DOCKER_BUILDKIT=1 docker build --tag mygolangbins:release --target release .
#           To execute the binaries of the release stage, run 
#           docker run --rm mygolangbins:release /bin/hello-world-0
#           and
#           docker run --rm mygolangbins:release /bin/hello-world-1
#
#           Build the dev-stage with DOCKER_BUILDKIT=1 docker build --tag mygolangbins:dev-env --target dev-env .
#           Use the dev-stage with docker run -it  mygolangbins:dev-env
#           You can now debug your the binaries from production
#
#           Build the test-stage with DOCKER_BUILDKIT=1 docker build --tag mygolangbins:test --target test .
#           Change this Dockerfile by adding the go test command to the test stage


# TODO: Write stage0 and stage 1 smarter

# stage0 builds the first binary
FROM golang:alpine AS stage0
WORKDIR /binary
RUN echo -e "package main\n import \"fmt\"\nfunc main() {fmt.Println(\"hello world from binary 0\")}" > hello-world-0.go && \
    go build hello-world-0.go && \
    rm hello-world-0.go

# stage1 builds the second binary
FROM golang:alpine AS stage1
WORKDIR /binary
RUN echo -e "package main\n import \"fmt\"\nfunc main() {fmt.Println(\"hello world from binary 1\")}" > hello-world-1.go && \
    go build hello-world-1.go && \
    rm hello-world-1.go

# a minimal release stage
FROM scratch AS release
COPY --from=stage0 /binary /bin
COPY --from=stage1 /binary /bin

# dev stage. Identical to release. Play around with binaries here
FROM golang:alpine AS dev-env
COPY --from=release / /
WORKDIR /bin
ENTRYPOINT ["ash"]

# testing stage. Identical to release. Run tests here
FROM golang:alpine AS test
COPY --from=release / /
# insert go test here!

# build release by default
FROM release