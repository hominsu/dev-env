# syntax=docker/dockerfile:1.4
ARG ALPINE_VERSION

FROM alpine:${ALPINE_VERSION} AS build

# image info
ARG AUTHOR_NAME
ARG AUTHOR_EMAIL
ARG VERSION

# label
LABEL author=${AUTHOR_NAME} email=${AUTHOR_EMAIL} version=${VERSION}

WORKDIR /tmp/workdir

ARG PREFIX=/usr/local

ENV OPENCOREAMR_VERSION=0.1.5   \
    X264_VERSION=20191217-2245-stable \
    X265_VERSION=3.2            \
    OGG_VERSION=1.3.5           \
    OPUS_VERSION=1.3.1          \
    VORBIS_VERSION=1.3.7        \
    THEORA_VERSION=1.1.1        \
    VPX_VERSION=1.11.0          \
    LAME_VERSION=3.100          \
    XVID_VERSION=1.3.5          \
    FDKAAC_VERSION=2.0.2        \
    OPENJPEG_VERSION=2.4.0      \
    FREETYPE_VERSION=2.12.0     \
    LIBVIDSTAB_VERSION=1.1.0    \
    FRIBIDI_VERSION=1.0.12      \
    FONTCONFIG_VERSION=2.14.0   \
    LIBASS_VERSION=0.15.2       \
    KVAZAAR_VERSION=2.1.0

RUN apk add --update --no-cache autoconf automake bash binutils bzip2 \
    git cmake curl coreutils diffutils expat-dev file g++ gcc gperf libtool \
    flex bison make python3 openssl-dev libcrypto1.1 libssl1.1 tar nasm yasm zlib-dev \
    libgcc libstdc++ ca-certificates harfbuzz

# opencore-amr https://sourceforge.net/projects/opencore-amr/
RUN DIR=$(mktemp -d) && cd ${DIR} && \
    curl -sL https://kent.dl.sourceforge.net/project/opencore-amr/opencore-amr/opencore-amr-${OPENCOREAMR_VERSION}.tar.gz | \
    tar -zx --strip-components=1 && \
    ./configure --prefix="${PREFIX}" --enable-shared  && \
    make -j $(nproc) && \
    make install && \
    rm -rf ${DIR}

# x264 http://www.videolan.org/developers/x264.html
RUN DIR=$(mktemp -d) && cd ${DIR} && \
    curl -sL https://download.videolan.org/pub/videolan/x264/snapshots/x264-snapshot-${X264_VERSION}.tar.bz2 | \
    tar -jx --strip-components=1 && \
    ./configure --prefix="${PREFIX}" --enable-shared --enable-pic --disable-cli && \
    make -j $(nproc) && \
    make install && \
    rm -rf ${DIR}

# x265 http://x265.org/
RUN DIR=$(mktemp -d) && cd ${DIR} && \
    curl -sL https://download.videolan.org/pub/videolan/x265/x265_${X265_VERSION}.tar.gz | \
    tar -zx --strip-components=1 && \
    cd build/linux && \
    sed -i "/-DEXTRA_LIB/ s/$/ -DCMAKE_INSTALL_PREFIX=\${PREFIX}/" multilib.sh && \
    sed -i "/^cmake/ s/$/ -DENABLE_CLI=OFF/" multilib.sh && \
    ./multilib.sh && make -C 8bit -j $(nproc) install && \
    rm -rf ${DIR}

# libogg https://www.xiph.org/ogg/
RUN DIR=$(mktemp -d) && cd ${DIR} && \
    curl -sL http://downloads.xiph.org/releases/ogg/libogg-${OGG_VERSION}.tar.gz | \
    tar -zx --strip-components=1 && \
    ./configure --prefix="${PREFIX}" --enable-shared  && \
    make -j $(nproc) && \
    make install && \
    rm -rf ${DIR}

# libopus https://www.opus-codec.org/
RUN DIR=$(mktemp -d) && cd ${DIR} && \
    curl -sL https://archive.mozilla.org/pub/opus/opus-${OPUS_VERSION}.tar.gz | \
    tar -zx --strip-components=1 && \
    autoreconf -fiv && \
    ./configure --prefix="${PREFIX}" --enable-shared && \
    make -j $(nproc) && \
    make install && \
    rm -rf ${DIR}

# libvorbis https://xiph.org/vorbis/
RUN DIR=$(mktemp -d) && cd ${DIR} && \
    curl -sL http://downloads.xiph.org/releases/vorbis/libvorbis-${VORBIS_VERSION}.tar.gz | \
    tar -zx --strip-components=1 && \
    ./configure --prefix="${PREFIX}" --with-ogg="${PREFIX}" --enable-shared && \
    make -j $(nproc) && \
    make install && \
    rm -rf ${DIR}

# libtheora http://www.theora.org/
RUN DIR=$(mktemp -d) && cd ${DIR} && \
    curl -sL http://downloads.xiph.org/releases/theora/libtheora-${THEORA_VERSION}.tar.gz | \
    tar -zx --strip-components=1 && \
    rm config.guess config.sub && \
    wget -q -O config.guess 'https://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.guess;hb=HEAD' && \
    wget -q -O config.sub 'https://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.sub;hb=HEAD' && \
    ./configure --prefix="${PREFIX}" --with-ogg="${PREFIX}" --enable-shared && \
    make -j $(nproc) && \
    make install && \
    rm -rf ${DIR}

# libvpx https://www.webmproject.org/code/
RUN DIR=$(mktemp -d) && cd ${DIR} && \
    curl -sL https://codeload.github.com/webmproject/libvpx/tar.gz/v${VPX_VERSION} | \
    tar -zx --strip-components=1 && \
    ./configure --prefix="${PREFIX}"  \
    --enable-vp8  \
    --enable-vp9  \
    --enable-pic  \
    --enable-shared  \
    --disable-debug  \
    --disable-examples  \
    --disable-docs \
    --disable-install-bins &&  \
    make -j $(nproc) &&  \
    make install &&  \
    rm -rf ${DIR}

# libmp3lame http://lame.sourceforge.net/
RUN DIR=$(mktemp -d) && cd ${DIR} && \
    curl -sL https://kent.dl.sourceforge.net/project/lame/lame/$(echo ${LAME_VERSION} | sed -e 's/[^0-9]*\([0-9]*\)[.]\([0-9]*\)[.]\([0-9]*\)\([0-9A-Za-z-]*\)/\1.\2/')/lame-${LAME_VERSION}.tar.gz | \
    tar -zx --strip-components=1 && \
    ./configure --prefix="${PREFIX}" --bindir="${PREFIX}/bin" --enable-shared --enable-nasm --enable-pic --disable-frontend && \
    make -j $(nproc) && \
    make install && \
    rm -rf ${DIR}

# xvid https://www.xvid.com/
RUN DIR=$(mktemp -d) && cd ${DIR} && \
    curl -sL http://downloads.xvid.org/downloads/xvidcore-${XVID_VERSION}.tar.gz | \
    tar -zx --strip-components=1 && \
    cd build/generic && \
    ./configure --prefix="${PREFIX}" --bindir="${PREFIX}/bin" --datadir="${DIR}" --enable-shared && \
    make -j $(nproc) && \
    make install && \
    rm -rf ${DIR}

# fdk-aac https://github.com/mstorsjo/fdk-aac
RUN DIR=$(mktemp -d) && cd ${DIR} && \
    curl -sL https://github.com/mstorsjo/fdk-aac/archive/v${FDKAAC_VERSION}.tar.gz | \
    tar -zx --strip-components=1 && \
    autoreconf -fiv && \
    ./configure --prefix="${PREFIX}" --enable-shared --datadir="${DIR}" && \
    make -j $(nproc) && \
    make install && \
    rm -rf ${DIR}

# openjpeg https://github.com/uclouvain/openjpeg
RUN DIR=$(mktemp -d) && cd ${DIR} && \
    curl -sL https://github.com/uclouvain/openjpeg/archive/v${OPENJPEG_VERSION}.tar.gz | \
    tar -zx --strip-components=1 && \
    cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="${PREFIX}" . && \
    make -j $(nproc) && \
    make install && \
    rm -rf ${DIR}

# freetype https://www.freetype.org/
RUN DIR=$(mktemp -d) && cd ${DIR} && \
    curl -sL http://download.savannah.gnu.org/releases/freetype/freetype-${FREETYPE_VERSION}.tar.gz | \
    tar -zx --strip-components=1 && \
    ./configure --prefix="${PREFIX}" --disable-static --enable-shared && \
    make -j $(nproc) && \
    make install && \
    rm -rf ${DIR}

# libvstab https://github.com/georgmartius/vid.stab
RUN DIR=$(mktemp -d) && cd ${DIR} && \
    curl -sL https://github.com/georgmartius/vid.stab/archive/v${LIBVIDSTAB_VERSION}.tar.gz | \
    tar -zx --strip-components=1 && \
    if [ $(uname -m) = "aarch64" ]; then \
    sed -i "/if(SSE2_FOUND)/i set(SSE2_FOUND false)" CMakeLists.txt ; \
    fi && \
    cmake -DCMAKE_INSTALL_PREFIX="${PREFIX}" . && \
    make -j $(nproc) && \
    make install && \
    rm -rf ${DIR}

# o2man
RUN DIR=$(mktemp -d) && cd ${DIR} && \
    git clone https://github.com/fribidi/c2man.git ${DIR} --depth=1 && \
    ./Configure -dE && \
    sh config_h.SH && sh flatten.SH && sh Makefile.SH && \
    make depend && \
    make -j $(nproc) && \
    make install && \
    rm -rf ${DIR}

# fridibi https://www.fribidi.org/
RUN DIR=$(mktemp -d) && cd ${DIR} && \
    curl -sL https://github.com/fribidi/fribidi/archive/v${FRIBIDI_VERSION}.tar.gz | \
    tar -zx --strip-components=1 && \
    ./autogen.sh && \
    ./configure --prefix="${PREFIX}" --disable-static --enable-shared && \
    make -j $(nproc) && \
    make install && \
    rm -rf ${DIR}

# fontconfig https://www.freedesktop.org/wiki/Software/fontconfig/
RUN DIR=$(mktemp -d) && cd ${DIR} && \
    curl -sL https://www.freedesktop.org/software/fontconfig/release/fontconfig-${FONTCONFIG_VERSION}.tar.gz | \
    tar -zx --strip-components=1 && \
    ./configure -prefix="${PREFIX}" --disable-static --enable-shared && \
    make -j $(nproc) && \
    make install && \
    rm -rf ${DIR}

# libass https://github.com/libass/libass
RUN DIR=$(mktemp -d) && cd ${DIR} && \
    apk add --no-cache harfbuzz-dev && \
    curl -sL https://github.com/libass/libass/archive/${LIBASS_VERSION}.tar.gz | \
    tar -zx --strip-components=1 && \
    ./autogen.sh && \
    ./configure -prefix="${PREFIX}" --disable-static --enable-shared && \
    make -j $(nproc) && \
    make install && \
    apk del harfbuzz-dev && \
    rm -rf ${DIR}

# kvazaar https://github.com/ultravideo/kvazaar
RUN DIR=$(mktemp -d) && cd ${DIR} && \
    curl -sL https://github.com/ultravideo/kvazaar/archive/v${KVAZAAR_VERSION}.tar.gz | \
    tar -zx --strip-components=1 && \
    ./autogen.sh && \
    ./configure -prefix="${PREFIX}" --disable-static --enable-shared && \
    make -j $(nproc) && \
    make install && \
    rm -rf ${DIR}

# aom https://aomedia.org/av1-features/get-started/
RUN DIR=$(mktemp -d) && cd ${DIR} && \
    curl -sLO https://aomedia.googlesource.com/aom/+archive/main.tar.gz && \
    tar -zx -f main.tar.gz && \
    rm -rf CMakeCache.txt CMakeFiles && \
    mkdir -p ./aom_build && \
    cd ./aom_build && \
    cmake -DCMAKE_INSTALL_PREFIX="${PREFIX}" -DBUILD_SHARED_LIBS=1 .. && \
    make -j $(nproc) && \
    make install && \
    rm -rf ${DIR}

RUN rm -rf /var/cache/apk/* && \
    hash -r
