# syntax=docker/dockerfile:1.4
ARG REPO
ARG ALPINE_VERSION
ARG GRPC_VERSION

FROM ${REPO}/grpc-alpine:grpc-${GRPC_VERSION}-alpine-${ALPINE_VERSION}-devel as devel
FROM alpine:${ALPINE_VERSION} AS build

# image info
ARG AUTHOR_NAME
ARG AUTHOR_EMAIL
ARG VERSION
ARG ALPINE_VERSION
ARG GRPC_VERSION

# label
LABEL author=${AUTHOR_NAME} email=${AUTHOR_EMAIL} version=${VERSION} alpine_version=${ALPINE_VERSION} grpc_version=${GRPC_VERSION}

COPY --from=devel /usr/local/bin /usr/local/bin
COPY --from=devel /usr/local/share /usr/local/share
COPY --from=devel /usr/local/include /usr/local/include
COPY --from=devel /usr/local/lib /usr/local/lib

ENV GRPC_CORE="musl \
                libgcc \
                libstdc++"

RUN apk add --no-cache ${GRPC_CORE} &&  \
    rm -rf /var/cache/apk/* &&  \
    hash -r