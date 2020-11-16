# File shows how to write a conditional dockerfile
#
# Usage:    docker build --build-arg my_arg=1 --file conditional.dockerfile . 
#               to build using branch-version-1
#           docker build --build-arg my_arg=2 --file conditional.dockerfile .
#               to build using branch-version-2

ARG my_arg

# a base image
FROM centos:7 AS base
RUN echo "do stuff with the centos image"

# the first conditional branch
FROM base AS branch-version-1
RUN echo "this is the stage that sets VAR=TRUE"
ENV VAR=TRUE

# the second conditional branch
FROM base AS branch-version-2
RUN echo "this is the stage that sets VAR=FALSE"
ENV VAR=FALSE

# choose a conditional branch based on the build argument my_arg
FROM branch-version-${my_arg} AS final
RUN echo "VAR is equal to ${VAR}"