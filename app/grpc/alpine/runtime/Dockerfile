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

ARG PREFIX=/usr/local

COPY --from=devel ${PREFIX}/bin ${PREFIX}/bin
COPY --from=devel ${PREFIX}/lib ${PREFIX}/lib
COPY --from=devel ${PREFIX}/share ${PREFIX}/share
COPY --from=devel ${PREFIX}/include ${PREFIX}/include

ENV GRPC_CORE="musl \
                libgcc \
                libstdc++"

RUN apk add --no-cache ${GRPC_CORE} &&  \
    rm -rf /var/cache/apk/* &&  \
    hash -r