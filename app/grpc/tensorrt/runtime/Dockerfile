# syntax=docker/dockerfile:1.4
ARG REPO
ARG DEBIAN_VERSION
ARG GRPC_VERSION
ARG TENSORRT_VERSION

FROM ${REPO}/grpc-tensorrt:grpc-${GRPC_VERSION}-${DEBIAN_VERSION}-devel as devel
FROM nvcr.io/nvidia/tensorrt:${TENSORRT_VERSION}

# image info
ARG AUTHOR_NAME
ARG AUTHOR_EMAIL
ARG VERSION
ARG DEBIAN_VERSION
ARG GRPC_VERSION
ARG TENSORRT_VERSION

# label
LABEL author=${AUTHOR_NAME} email=${AUTHOR_EMAIL} version=${VERSION} debian_version=${DEBIAN_VERSION} grpc_version=${GRPC_VERSION} tensorrt_version=${TENSORRT_VERSION}

COPY --from=devel /usr/local/bin /usr/local/bin
COPY --from=devel /usr/local/share /usr/local/share
COPY --from=devel /usr/local/lib /usr/local/lib
