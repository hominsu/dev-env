FROM hominsu/ffmpeg-alpine:deps AS deps
FROM alpine:3.15

WORKDIR /tmp/workdir

ARG PKG_CONFIG_PATH=/usr/local/ffmpeg/pkgconfig
ARG LD_LIBRARY_PATH=/usr/local/ffmpeg
ARG PREFIX=/usr/local
ENV FFMPEG_VERSION=5.0

RUN apk add --update --no-cache autoconf automake bash binutils bzip2 \
    cmake curl coreutils diffutils expat-dev file g++ gcc gperf libtool \
    make python3 openssl-dev libcrypto1.1 libssl1.1 tar nasm yasm zlib-dev \
    musl libgcc libstdc++ ca-certificates harfbuzz

COPY --from=deps ${PREFIX}/bin ${PREFIX}/bin
COPY --from=deps ${PREFIX}/lib ${PREFIX}/lib
COPY --from=deps ${PREFIX}/share ${PREFIX}/share
COPY --from=deps ${PREFIX}/include ${PREFIX}/include

ENV BUILD_OPTIONS="--disable-debug \
                   --disable-doc \
                   --disable-ffplay \
                   --enable-shared \
                   --enable-libopencore-amrnb \
                   --enable-libopencore-amrwb \
                   --enable-gpl \
                   --enable-libass \
                   --enable-libfreetype \
                   --enable-libvidstab \
                   --enable-libmp3lame \
                   --enable-libopenjpeg \
                   --enable-libopus \
                   --enable-libtheora \
                   --enable-libvorbis \
                   --enable-libvpx \
                   --enable-libxvid \
                   --enable-libx264 \
                   --enable-libx265 \
                   --enable-nonfree \
                   --enable-openssl \
                   --enable-libfdk_aac \
                   --enable-libkvazaar \
                   --enable-libaom --extra-libs=-lpthread \
                   --enable-postproc \
                   --enable-small \
                   --enable-version3 \
                   --extra-cflags=-I${PREFIX}/include \
                   --extra-ldflags=-L${PREFIX}/lib \
                   --extra-libs=-ldl \
                   --prefix=${PREFIX}"

# ffmpeg https://ffmpeg.org/
RUN export build_options=${BUILD_OPTIONS} && \
    DIR=$(mktemp -d) && cd ${DIR} && \
    curl -sL https://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.bz2 | \
    tar -jx --strip-components=1 && \
    ./configure ${build_options} && \
    make -j $(nproc) && \
    make install && \
    make distclean && \
    rm -rf ${DIR}

RUN mkdir -p /tmp/fakeroot/lib  && \
    ldd ${PREFIX}/bin/ffmpeg | cut -d ' ' -f 3 | strings | xargs -I R cp R /tmp/fakeroot/lib/ && \
    for lib in /tmp/fakeroot/lib/*; do strip --strip-all $lib; done && \
    cp -r ${PREFIX}/bin /tmp/fakeroot/bin/ && \
    cp -r ${PREFIX}/share /tmp/fakeroot/share/ && \
    cp -r ${PREFIX}/include /tmp/fakeroot/include && \
    LD_LIBRARY_PATH=/tmp/fakeroot/lib /tmp/fakeroot/bin/ffmpeg -buildconf

RUN ls -la /tmp/fakeroot && \
    rm -rf /var/cache/apk/* && \
    hash -r
