# syntax=docker/dockerfile:1.4
ARG DEBIAN_VERSION

FROM debian:${DEBIAN_VERSION}-slim as base

# image info
ARG AUTHOR_NAME
ARG AUTHOR_EMAIL
ARG VERSION

# label
LABEL author=${AUTHOR_NAME} email=${AUTHOR_EMAIL} version=${VERSION}

WORKDIR /tmp/workdir

RUN apt-get -yqq update &&  \
    apt-get install -yq --no-install-recommends  \
    curl  \
    ca-certificates  \
    expat libgomp1  \
    libva-drm2 libva2 &&  \
    apt-get autoremove -y &&  \
    apt-get clean -y
