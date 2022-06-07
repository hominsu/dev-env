# syntax=docker/dockerfile:1.4
ARG ALPINE_VERSION

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

ENV GRPC_VERSION=${GRPC_VERSION}

ENV GRPC_CORE="abseil-cpp \
                c-ares \
                libcrypto1.1 \
                libgcc \
                libprotobuf \
                libprotoc \
                libssl1.1 \
                libstdc++ \
                musl \
                protobuf \
                re2 \
                zlib"

ENV BUILD_DEPS="abseil-cpp-dev \
                autoconf \
                automake \
                c-ares-dev \
                chrpath \
                libexecinfo-dev \
                libtool \
                openssl1.1-compat-dev \
                protobuf-dev \
                re2-dev \
                samurai \
                yaml-dev \
                zlib-dev"

ENV RUNTIME_DEPS="bash \
                    build-base \
                    curl \
                    cmake \
                    coreutils \
                    linux-headers"

RUN apk update && \
    apk add --no-cache --virtual .runtime-deps ${RUNTIME_DEPS} && \
    apk add --no-cache ${GRPC_CORE} && \
    apk add --no-cache --virtual .build-deps ${BUILD_DEPS} && \
	DIR=$(mktemp -d) && cd ${DIR} && \
    curl -sL https://github.com/grpc/grpc/archive/v${GRPC_VERSION}/grpc-v${GRPC_VERSION}.tar.gz | \
    tar -zx --strip-components=1 && \
	cmake -B build \
    -DCMAKE_BUILD_TYPE=MinSizeRel \
    -DCMAKE_INSTALL_PREFIX=${PREFIX} \
    -DCMAKE_CXX_FLAGS="$CXXFLAGS -w" \
    -DCMAKE_C_FLAGS="$CFLAGS -w" \
    -DCMAKE_CXX_STANDARD=17 \
    -DBUILD_SHARED_LIBS=True \
    -DgRPC_INSTALL=ON \
    -DgRPC_CARES_PROVIDER=package \
    -DgRPC_PROTOBUF_PROVIDER=package \
    -DgRPC_SSL_PROVIDER=package \
    -DgRPC_ZLIB_PROVIDER=package \
    -DgRPC_ABSL_PROVIDER=package \
    -DgRPC_BENCHMARK_PROVIDER=package \
    -DgRPC_RE2_PROVIDER=package \
    -DgRPC_BUILD_TESTS=OFF \
    -G Ninja && \
    cmake --build build --parallel && \
    cmake --install build && \
    rm -rf ${DIR} && \
    rm ${PREFIX}/share/grpc/roots.pem && \
    apk del .build-deps && \
    apk del .runtime-deps && \
    rm -rf /var/cache/apk/* && \
    hash -r
