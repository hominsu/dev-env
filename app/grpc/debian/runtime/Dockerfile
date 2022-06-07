# syntax=docker/dockerfile:1.4
ARG REPO
ARG DEBIAN_VERSION
ARG GRPC_VERSION

FROM ${REPO}/grpc-debian:grpc-${GRPC_VERSION}-${DEBIAN_VERSION}-devel as devel
FROM debian:${DEBIAN_VERSION}

# image info
ARG AUTHOR_NAME
ARG AUTHOR_EMAIL
ARG VERSION
ARG DEBIAN_VERSION
ARG GRPC_VERSION

# label
LABEL author=${AUTHOR_NAME} email=${AUTHOR_EMAIL} version=${VERSION} debian_version=${DEBIAN_VERSION} grpc_version=${GRPC_VERSION}

ARG PREFIX=/usr/local

COPY --from=devel ${PREFIX}/bin ${PREFIX}/bin
COPY --from=devel ${PREFIX}/lib ${PREFIX}/lib
COPY --from=devel ${PREFIX}/share ${PREFIX}/share
COPY --from=devel ${PREFIX}/include ${PREFIX}/include
