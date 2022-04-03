FROM alpine:3.15

ENV FFMPEG_VERSION=5.0

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
    apk add --no-cache --virtual .build-deps ${BUILD_DEPS}

RUN export SRC=/usr \
	DIR=$(mktemp -d) && cd ${DIR} && \
	curl -sLO https://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.bz2 && \
    tar -jx --strip-components=1 -f ffmpeg-${FFMPEG_VERSION}.tar.bz2 && \
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
	hash -r && \
	cd /tmp && \
	rm -rf ${DIR}

RUN apk del .build-deps && \
	apk del .runtime-deps && \
    rm -rf /var/cache/apk/*