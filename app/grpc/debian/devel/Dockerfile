# syntax=docker/dockerfile:1.4
ARG REPO
ARG DEBIAN_VERSION
ARG GRPC_VERSION

FROM ${REPO}/grpc-debian:grpc-${GRPC_VERSION}-${DEBIAN_VERSION}-deps as deps
FROM debian:${DEBIAN_VERSION} AS build

# image info
ARG AUTHOR_NAME
ARG AUTHOR_EMAIL
ARG VERSION
ARG DEBIAN_VERSION
ARG GRPC_VERSION

# label
LABEL author=${AUTHOR_NAME} email=${AUTHOR_EMAIL} version=${VERSION} debian_version=${DEBIAN_VERSION} grpc_version=${GRPC_VERSION}

ARG PREFIX=/usr/local

COPY --from=deps ${PREFIX}/bin ${PREFIX}/bin
COPY --from=deps ${PREFIX}/lib ${PREFIX}/lib
COPY --from=deps ${PREFIX}/share ${PREFIX}/share
COPY --from=deps ${PREFIX}/include ${PREFIX}/include
COPY --from=deps ${PREFIX}/ssl ${PREFIX}/ssl

ENV GRPC_VERSION=${GRPC_VERSION}

ENV BUILD_DEPS="autoconf        \
                automake        \
                build-essential \
                ca-certificates \
                cmake           \
                git             \
                libtool         \
                netbase         \
                ninja-build     \
                pkg-config"

RUN apt-get update && \
    apt-get install -y --no-install-recommends ${BUILD_DEPS} && \
    rm -rf /var/lib/apt/lists/ && \
    apt-get autoremove -y && \
    apt-get autoclean -y

RUN DIR=$(mktemp -d) && cd ${DIR} && \
    git clone -b v${GRPC_VERSION} --depth 1 https://github.com/grpc/grpc ${DIR} &&  \
    cmake -B build \
    -DCMAKE_BUILD_TYPE=MinSizeRel \
    -DCMAKE_INSTALL_PREFIX="${PREFIX}" \
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
    rm -rf ${PREFIX}/share/grpc/roots.pem && \
    rm -rf ${DIR}

