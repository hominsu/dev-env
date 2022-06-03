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

ENV GTEST_VERSION=1.11.0    \
    BENCHMARK_VERSION=1.6.1 \
    CARES_VERSION=1.18.1    \
    ABSEILCPP_VERSION=20211102.0    \
    OPENSSL_VSERION=1.1.1o  \
    ZLIB_VERSION=1.2.12 \
    RE2_VERSION=2022-06-01  \
    PROTOBUF_VERSION=3.18.1

ENV BUILD_DEPS="autoconf \
                automake \
                build-base \
                cmake   \
                libtool \
                python3-dev \
                samurai"

ENV RUNTIME_DEPS="bash  \
                    ca-certificates \
                    coreutils   \
                    curl    \
                    linux-headers"

RUN apk update &&  \
    apk add --no-cache --virtual .runtime-deps ${RUNTIME_DEPS} &&  \
    apk add --no-cache --virtual .build-deps ${BUILD_DEPS}

# googletest googlemock https://github.com/google/googletest/
RUN DIR=$(mktemp -d) && cd ${DIR} && \
    curl -sL https://github.com/google/googletest/archive/release-${GTEST_VERSION}.tar.gz | \
    tar -zx --strip-components=1 && \
    cmake -B build \
    -DCMAKE_BUILD_TYPE=MinSizeRel \
    -DCMAKE_INSTALL_PREFIX="${PREFIX}" \
    -DCMAKE_INSTALL_LIBDIR=lib \
    -DBUILD_SHARED_LIBS=ON \
    -DPYTHON_EXECUTABLE=python3 \
    -Dgtest_build_tests=OFF \
    -DBUILD_GMOCK=ON  \
    -G Ninja && \
    cmake --build build --parallel && \
    cmake --install build && \
    rm -rf ${DIR}

# benchmark https://github.com/google/benchmark
RUN DIR=$(mktemp -d) && cd ${DIR} && \
    curl -sL https://github.com/google/benchmark/archive/v${BENCHMARK_VERSION}.tar.gz | \
    tar -zx --strip-components=1 && \
    cmake -B build \
    -DCMAKE_BUILD_TYPE=MinSizeRel \
    -DCMAKE_INSTALL_PREFIX="${PREFIX}" \
    -DCMAKE_INSTALL_LIBDIR=lib \
    -DBUILD_SHARED_LIBS=True \
    -DBENCHMARK_ENABLE_ASSEMBLY_TESTS=OFF \
    -DBENCHMARK_ENABLE_DOXYGEN=OFF \
    -DBENCHMARK_ENABLE_LTO=ON \
    -DBENCHMARK_ENABLE_WERROR=OFF \
    -DBENCHMARK_USE_BUNDLED_GTEST=OFF \
    -G Ninja && \
    cmake --build build --parallel && \
    cmake --install build && \
    rm -rf ${PREFIX}/share/doc/benchmark \
    rm -rf ${DIR}

# c-ares https://c-ares.haxx.se/
RUN DIR=$(mktemp -d) && cd ${DIR} && \
    curl -sL https://c-ares.haxx.se/download/c-ares-${CARES_VERSION}.tar.gz | \
    tar -zx --strip-components=1 && \
    ./configure --prefix="${PREFIX}" --enable-shared --mandir="${PREFIX}/share/man" --infodir="${PREFIX}/share/info" && \
    make -j $(nproc) && \
    make install && \
    rm -rf ${DIR}

# abseil-cpp https://abseil.io/
RUN DIR=$(mktemp -d) && cd ${DIR} && \
    curl -sL https://github.com/abseil/abseil-cpp/archive/${ABSEILCPP_VERSION}/abseil-cpp-${ABSEILCPP_VERSION}.tar.gz | \
    tar -zx --strip-components=1 && \
    cmake -B build \
    -DCMAKE_CXX_STANDARD=17 \
    -DCMAKE_BUILD_TYPE=MinSizeRel \
    -DCMAKE_INSTALL_PREFIX="${PREFIX}" \
    -DCMAKE_INSTALL_LIBDIR=lib \
    -DBUILD_SHARED_LIBS=ON \
    -DBUILD_TESTING=OFF \
    -DABSL_USE_EXTERNAL_GOOGLETEST=OFF \
    -DABSL_PROPAGATE_CXX_STD=ON \
    -DABSL_FIND_GOOGLETEST=OFF \
    -G Ninja && \
    cmake --build build --parallel && \
    cmake --install build && \
    rm -rf ${DIR}

# openssl https://www.openssl.org/
RUN DIR=$(mktemp -d) && cd ${DIR} && \
    curl -sL https://www.openssl.org/source/openssl-${OPENSSL_VSERION}.tar.gz | \
    tar -zx --strip-components=1 && \
    ./config --prefix="${PREFIX}" && \
    make -j $(nproc) && \
    make install_sw install_ssldirs && \
    rm -rf ${DIR}

# zlib https://zlib.net/
RUN DIR=$(mktemp -d) && cd ${DIR} && \
    curl -sL https://zlib.net/zlib-${ZLIB_VERSION}.tar.gz | \
    tar -zx --strip-components=1 && \
    ./configure --prefix="${PREFIX}" --shared --libdir="${PREFIX}/lib" && \
    make -j $(nproc) && \
    make install && \
    rm -rf ${DIR}

# re2 https://github.com/google/re2
RUN DIR=$(mktemp -d) && cd ${DIR} && \
    curl -sL https://github.com/google/re2/archive/${RE2_VERSION}.tar.gz | \
    tar -zx --strip-components=1 && \
    make -j $(nproc) && \
    make prefix="${PREFIX}" install && \
    rm -rf ${DIR}

# protobuf https://github.com/google/protobuf/
RUN DIR=$(mktemp -d) && cd ${DIR} && \
    curl -sL https://github.com/google/protobuf/archive/v${PROTOBUF_VERSION}.tar.gz | \
    tar -zx --strip-components=1 && \
    ./autogen.sh && \
    ./configure --prefix="${PREFIX}" \
    --sysconfdir=/etc \
    --mandir=/usr/share/man \
    --infodir=/usr/share/info \
    --localstatedir=/var && \
    make -j $(nproc) && \
    make prefix="${PREFIX}" install && \
    rm -rf ${DIR}

RUN apk del .build-deps &&  \
    apk del .runtime-deps && \
    rm -rf /usr/share/man/man3 && \
    rm -rf ${PREFIX}/share/man/man3 && \
    rm -rf /var/cache/apk/* &&  \
    hash -r
