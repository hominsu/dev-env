# syntax=docker/dockerfile:1.4
ARG ALPINE_VERSION

FROM alpine:${ALPINE_VERSION} AS build

# image info
ARG AUTHOR_NAME
ARG AUTHOR_EMAIL
ARG VERSION
ARG ALPINE_VERSION
ARG FFMPEG_VERSION

# label
LABEL author=${AUTHOR_NAME} email=${AUTHOR_EMAIL} version=${VERSION} alpine_version=${ALPINE_VERSION} ffmpeg_version=${FFMPEG_VERSION}

ENV FFMPEG_VERSION=${FFMPEG_VERSION}

ENV FFMPEG_CORE="bash \
                 tzdata \
                 libass \
                 libstdc++ \
                 libpng \
                 libjpeg \
                 xvidcore \
                 x264-libs \
                 x265 \
                 libvpx \
                 libvorbis \
                 opus \
                 lame \
                 fdk-aac \
                 freetype \
                 libcrypto1.1 \
                 libssl1.1 \
                 libavc1394 \
                 nasm \
                 yasm"

ENV RUNTIME_DEPS="coreutils \
                  make \
                  cmake \
                  gcc \
                  g++ \
                  clang \
                  linux-headers \
                  git \
                  curl"

ENV BUILD_DEPS="fdk-aac-dev \
                freetype-dev \
                x264-dev \
                x265-dev \
                yasm-dev \
                libogg-dev \
                libvorbis-dev \
                opus-dev \
                libvpx-dev \
                lame-dev \
                xvidcore-dev \
                libass-dev \
                openssl-dev \
                musl-dev \
                build-base \
                libjpeg-turbo-dev \
                libpng-dev \
                libavc1394-dev \
                libavc1394-dev \
                clang-dev"

RUN apk update && \
    apk add --no-cache --virtual .runtime-deps ${RUNTIME_DEPS} && \
    apk add --no-cache ${FFMPEG_CORE} && \
    apk add --no-cache --virtual .build-deps ${BUILD_DEPS} && \
    export SRC=/usr \
	DIR=$(mktemp -d) && cd ${DIR} && \
	curl -sL https://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.bz2 | \
    tar -jx --strip-components=1 && \
	./configure \
    --prefix="${SRC}" \
    --extra-cflags="-I${SRC}/include" \
    --extra-ldflags="-L${SRC}/lib" \
    --bindir="${SRC}/bin" \
    --extra-libs=-ldl \
    --enable-version3 \
    --enable-libmp3lame \
    --enable-pthreads \
    --enable-libx264 \
    --enable-libxvid \
    --enable-gpl \
    --enable-postproc \
    --enable-nonfree \
    --enable-libfdk-aac \
    --disable-debug \
    --enable-small \
    --enable-openssl \
    --enable-libx265 \
    --enable-libopus \
    --enable-libvorbis \
    --enable-libvpx \
    --enable-libfreetype \
    --enable-libass \
    --enable-shared \
    --enable-pic && \
    make -j $(nproc) && \
    make install && \
    make distclean && \
	rm -rf ${DIR} &&  \
    apk del .build-deps && \
	apk del .runtime-deps && \
    rm -rf /var/cache/apk/* && \
    hash -r
