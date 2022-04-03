FROM alpine:3.15 AS build

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
    FRIBIDI_VERSION=1.0.11      \
    FONTCONFIG_VERSION=2.14.0   \
    LIBASS_VERSION=0.15.2       \
    KVAZAAR_VERSION=2.1.0       \
    AOM_VERSION=master          \

    SRC=/usr/local

RUN apk add --update autoconf automake bash binutils bzip2 cmake \
    curl coreutils diffutils expat-dev file g++ gcc gperf libtool \
    make openssl-dev tar yasm zlib-dev libgcc libstdc++ \
    ca-certificates libcrypto1.1 libssl1.1

# opencore-amr https://sourceforge.net/projects/opencore-amr/
RUN DIR=/tmp/opencore-amr && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    curl -sL https://kent.dl.sourceforge.net/project/opencore-amr/opencore-amr/opencore-amr-${OPENCOREAMR_VERSION}.tar.gz | \
    tar -zx --strip-components=1 && \
    ./configure --prefix="${PREFIX}" --enable-shared  && \
    make -j $(nproc) && \
    make install && \
    rm -rf ${DIR}

# x264 http://www.videolan.org/developers/x264.html
RUN DIR=/tmp/x264 && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    curl -sL https://download.videolan.org/pub/videolan/x264/snapshots/x264-snapshot-${X264_VERSION}.tar.bz2 | \
    tar -jx --strip-components=1 && \
    ./configure --prefix="${PREFIX}" --enable-shared --enable-pic --disable-cli && \
    make -j $(nproc) && \
    make install && \
    rm -rf ${DIR}

# x265 http://x265.org/
RUN DIR=/tmp/x265 && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    curl -sL https://download.videolan.org/pub/videolan/x265/x265_${X265_VERSION}.tar.gz  | \
    tar -zx && \
    cd x265_${X265_VERSION}/build/linux && \
    sed -i "/-DEXTRA_LIB/ s/$/ -DCMAKE_INSTALL_PREFIX=\${PREFIX}/" multilib.sh && \
    sed -i "/^cmake/ s/$/ -DENABLE_CLI=OFF/" multilib.sh && \
    ./multilib.sh && \
    make -C 8bit install && \
    rm -rf ${DIR}

# libogg https://www.xiph.org/ogg/
RUN DIR=/tmp/ogg && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    curl -sLO http://downloads.xiph.org/releases/ogg/libogg-${OGG_VERSION}.tar.gz && \
    tar -zx --strip-components=1 -f libogg-${OGG_VERSION}.tar.gz && \
    ./configure --prefix="${PREFIX}" --enable-shared  && \
    make -j $(nproc) && \
    make install && \
    rm -rf ${DIR}

# libopus https://www.opus-codec.org/
RUN DIR=/tmp/opus && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    curl -sLO https://archive.mozilla.org/pub/opus/opus-${OPUS_VERSION}.tar.gz && \
    tar -zx --strip-components=1 -f opus-${OPUS_VERSION}.tar.gz && \
    autoreconf -fiv && \
    ./configure --prefix="${PREFIX}" --enable-shared && \
    make -j $(nproc) && \
    make install && \
    rm -rf ${DIR}

# libvorbis https://xiph.org/vorbis/
RUN DIR=/tmp/vorbis && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    curl -sLO http://downloads.xiph.org/releases/vorbis/libvorbis-${VORBIS_VERSION}.tar.gz && \
    tar -zx --strip-components=1 -f libvorbis-${VORBIS_VERSION}.tar.gz && \
    ./configure --prefix="${PREFIX}" --with-ogg="${PREFIX}" --enable-shared && \
    make -j $(nproc) && \
    make install && \
    rm -rf ${DIR}

# libtheora http://www.theora.org/
RUN DIR=/tmp/theora && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    curl -sLO http://downloads.xiph.org/releases/theora/libtheora-${THEORA_VERSION}.tar.gz && \
    tar -zx --strip-components=1 -f libtheora-${THEORA_VERSION}.tar.gz && \
    ./configure --prefix="${PREFIX}" --with-ogg="${PREFIX}" --enable-shared && \
    make -j $(nproc) && \
    make install && \
    rm -rf ${DIR}

# libvpx https://www.webmproject.org/code/
RUN DIR=/tmp/vpx && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    curl -sL https://codeload.github.com/webmproject/libvpx/tar.gz/v${VPX_VERSION} | \
    tar -zx --strip-components=1 && \
    ./configure --prefix="${PREFIX}" --enable-vp8 --enable-vp9 --enable-pic --enable-shared \
    --disable-debug --disable-examples --disable-docs --disable-install-bins  && \
    make -j $(nproc) && \
    make install && \
    rm -rf ${DIR}

# libmp3lame http://lame.sourceforge.net/
RUN DIR=/tmp/lame && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    curl -sL https://kent.dl.sourceforge.net/project/lame/lame/$(echo ${LAME_VERSION} | sed -e 's/[^0-9]*\([0-9]*\)[.]\([0-9]*\)[.]\([0-9]*\)\([0-9A-Za-z-]*\)/\1.\2/')/lame-${LAME_VERSION}.tar.gz | \
    tar -zx --strip-components=1 && \
    ./configure --prefix="${PREFIX}" --bindir="${PREFIX}/bin" --enable-shared --enable-nasm --enable-pic --disable-frontend && \
    make -j $(nproc) && \
    make install && \
    rm -rf ${DIR}

# xvid https://www.xvid.com/
RUN DIR=/tmp/xvid && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    curl -sLO http://downloads.xvid.org/downloads/xvidcore-${XVID_VERSION}.tar.gz && \
    tar -zx -f xvidcore-${XVID_VERSION}.tar.gz && \
    cd xvidcore/build/generic && \
    ./configure --prefix="${PREFIX}" --bindir="${PREFIX}/bin" --datadir="${DIR}" --enable-shared --enable-shared && \
    make -j $(nproc) && \
    make install && \
    rm -rf ${DIR}

# fdk-aac https://github.com/mstorsjo/fdk-aac
RUN DIR=/tmp/fdk-aac && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    curl -sL https://github.com/mstorsjo/fdk-aac/archive/v${FDKAAC_VERSION}.tar.gz | \
    tar -zx --strip-components=1 && \
    autoreconf -fiv && \
    ./configure --prefix="${PREFIX}" --enable-shared --datadir="${DIR}" && \
    make -j $(nproc) && \
    make install && \
    rm -rf ${DIR}

# openjpeg https://github.com/uclouvain/openjpeg
RUN DIR=/tmp/openjpeg && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    curl -sL https://github.com/uclouvain/openjpeg/archive/v${OPENJPEG_VERSION}.tar.gz | \
    tar -zx --strip-components=1 && \
    cmake -DBUILD_THIRDPARTY:BOOL=ON -DCMAKE_INSTALL_PREFIX="${PREFIX}" . && \
    make -j $(nproc) && \
    make install && \
    rm -rf ${DIR}

# freetype https://www.freetype.org/
RUN DIR=/tmp/freetype && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    curl -sLO http://download.savannah.gnu.org/releases/freetype/freetype-${FREETYPE_VERSION}.tar.gz && \
    tar -zx --strip-components=1 -f freetype-${FREETYPE_VERSION}.tar.gz && \
    ./configure --prefix="${PREFIX}" --disable-static --enable-shared && \
    make -j $(nproc) && \
    make install && \
    rm -rf ${DIR}

# libvstab https://github.com/georgmartius/vid.stab
RUN  DIR=/tmp/vid.stab && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    curl -sLO https://github.com/georgmartius/vid.stab/archive/v${LIBVIDSTAB_VERSION}.tar.gz && \
    tar -zx --strip-components=1 -f v${LIBVIDSTAB_VERSION}.tar.gz && \
    cmake -DCMAKE_INSTALL_PREFIX="${PREFIX}" . && \
    make -j $(nproc) && \
    make install && \
    rm -rf ${DIR}

# fridibi https://www.fribidi.org/
RUN DIR=/tmp/fribidi && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    curl -sLO https://github.com/fribidi/fribidi/archive/v${FRIBIDI_VERSION}.tar.gz && \
    tar -zx --strip-components=1 -f v${FRIBIDI_VERSION}.tar.gz && \
    ./bootstrap --no-config && \
    ./configure -prefix="${PREFIX}" --disable-static --enable-shared && \
    make -j $(nproc) && \
    make install && \
    rm -rf ${DIR}

# fontconfig https://www.freedesktop.org/wiki/Software/fontconfig/
RUN DIR=/tmp/fontconfig && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    curl -sLO https://www.freedesktop.org/software/fontconfig/release/fontconfig-${FONTCONFIG_VERSION}.tar.gz && \
    tar -zx --strip-components=1 -f fontconfig-${FONTCONFIG_VERSION}.tar.gz && \
    ./configure -prefix="${PREFIX}" --disable-static --enable-shared && \
    make -j $(nproc) && \
    make install && \
    rm -rf ${DIR}

# libass https://github.com/libass/libass
RUN DIR=/tmp/libass && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    curl -sLO https://github.com/libass/libass/archive/${LIBASS_VERSION}.tar.gz && \
    tar -zx --strip-components=1 -f ${LIBASS_VERSION}.tar.gz && \
    ./autogen.sh && \
    ./configure -prefix="${PREFIX}" --disable-static --enable-shared && \
    make -j $(nproc) && \
    make install && \
    rm -rf ${DIR}

# kvazaar https://github.com/ultravideo/kvazaar
RUN DIR=/tmp/kvazaar && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    curl -sLO https://github.com/ultravideo/kvazaar/archive/v${KVAZAAR_VERSION}.tar.gz && \
    tar -zx --strip-components=1 -f v${KVAZAAR_VERSION}.tar.gz && \
    ./autogen.sh && \
    ./configure -prefix="${PREFIX}" --disable-static --enable-shared && \
    make -j $(nproc) && \
    make install && \
    rm -rf ${DIR}

RUN DIR=/tmp/aom && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    curl -sLO https://aomedia.googlesource.com/aom/+archive/${AOM_VERSION}.tar.gz && \
    tar -zx -f ${AOM_VERSION}.tar.gz && \
    rm -rf CMakeCache.txt CMakeFiles && \
    mkdir -p ./aom_build && \
    cd ./aom_build && \
    cmake -DCMAKE_INSTALL_PREFIX="${PREFIX}" -DBUILD_SHARED_LIBS=1 .. && \
    make -j $(nproc) && \
    make install && \
    rm -rf ${DIR}