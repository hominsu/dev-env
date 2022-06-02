# syntax=docker/dockerfile:1.4
ARG ALPINE_VERSION

FROM alpine:${ALPINE_VERSION} AS devel

# image info
ARG AUTHOR_NAME
ARG AUTHOR_EMAIL
ARG VERSION
ARG ALPINE_VERSION
ARG GRPC_VERSION

# label
LABEL author=${AUTHOR_NAME} email=${AUTHOR_EMAIL} version=${VERSION} alpine_version=${ALPINE_VERSION} grpc_version=${GRPC_VERSION}

ENV GRPC_VERSION=${GRPC_VERSION}

ENV BUILD_DEPS="autoconf \
                automake \
                build-base \
                cmake \
                libtool \
                samurai"

ENV RUNTIME_DEPS="bash \
                    ca-certificates \
                    coreutils \
                    git \
                    linux-headers"

ARG PREFIX=/usr/local

RUN apk update &&  \
    apk add --no-cache --virtual .runtime-deps ${RUNTIME_DEPS} &&  \
    apk add --no-cache --virtual .build-deps ${BUILD_DEPS}

RUN DIR=$(mktemp -d) && cd ${DIR} && \
    git clone --recurse-submodules -b v${GRPC_VERSION} --depth 1 --shallow-submodules https://github.com/grpc/grpc ${DIR} &&  \
    cmake -B build \
    -DCMAKE_BUILD_TYPE=MinSizeRel \
    -DCMAKE_INSTALL_PREFIX=${PREFIX} \
    -DCMAKE_CXX_FLAGS="$CXXFLAGS -w" \
    -DCMAKE_C_FLAGS="$CFLAGS -w" \
    -DCMAKE_CXX_STANDARD=17 \
    -DBUILD_SHARED_LIBS=True \
    -DgRPC_INSTALL=ON \
    -DgRPC_CARES_PROVIDER=module \
    -DgRPC_PROTOBUF_PROVIDER=module \
    -DgRPC_SSL_PROVIDER=module \
    -DgRPC_ZLIB_PROVIDER=module \
    -DgRPC_ABSL_PROVIDER=module \
    -DgRPC_BENCHMARK_PROVIDER=module \
    -DgRPC_RE2_PROVIDER=module \
    -DgRPC_BUILD_TESTS=OFF \
    -G Ninja && \
    cmake --build build --parallel && \
    cmake --install build && \
    rm -rf ${DIR}

RUN apk del .build-deps &&  \
    apk del .runtime-deps &&  \
    rm -rf /var/cache/apk/* &&  \
    hash -r
