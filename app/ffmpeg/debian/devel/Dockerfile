# syntax=docker/dockerfile:1.4
ARG REPO
ARG DEBIAN_VERSION

FROM ${REPO}/ffmpeg-debian:${DEBIAN_VERSION}-slim-base AS base

# image info
ARG AUTHOR_NAME
ARG AUTHOR_EMAIL
ARG VERSION

# label
LABEL author=${AUTHOR_NAME} email=${AUTHOR_EMAIL} version=${VERSION}

ARG PKG_CONFIG_PATH=/opt/ffmpeg/lib/pkgconfig
ARG LD_LIBRARY_PATH=/opt/ffmpeg/lib
ARG PREFIX=/opt/ffmpeg

ENV FFMPEG_VERSION=5.0.1            \
    CHROMAPRINT_VERSION=1.5.0       \
    FDKAAC_VERSION=2.0.2            \
    FONTCONFIG_VERSION=2.14.0       \
    FREETYPE_VERSION=2.12.0         \
    FRIBIDI_VERSION=1.0.12          \
    KVAZAAR_VERSION=2.1.0           \
    LAME_VERSION=3.100              \
    LIBASS_VERSION=0.15.2           \
    LIBPTHREAD_STUBS_VERSION=0.4    \
    LIBVIDSTAB_VERSION=1.1.0        \
    LIBXCB_VERSION=1.13.1           \
    XCBPROTO_VERSION=1.13           \
    OGG_VERSION=1.3.5               \
    OPENCOREAMR_VERSION=0.1.5       \
    OPUS_VERSION=1.3.1              \
    OPENJPEG_VERSION=2.4.0          \
    THEORA_VERSION=1.1.1            \
    VORBIS_VERSION=1.3.7            \
    VPX_VERSION=1.11.0              \
    WEBP_VERSION=1.0.2              \
    X264_VERSION=20191217-2245-stable \
    X265_VERSION=3.5                \
    XAU_VERSION=1.0.9               \
    XORG_MACROS_VERSION=1.19.2      \
    XPROTO_VERSION=7.0.31           \
    XVID_VERSION=1.3.5              \
    LIBXML2_VERSION=2.9.12          \
    LIBBLURAY_VERSION=1.1.2         \
    LIBZMQ_VERSION=4.3.2            \
    LIBSRT_VERSION=1.4.1            \
    LIBARIBB24_VERSION=1.0.3        \
    LIBPNG_VERSION=1.6.9            \
    LIBVMAF_VERSION=2.1.1           \
    SRC=/usr/local

ARG  LD_LIBRARY_PATH=/opt/ffmpeg/lib
ARG  PKG_CONFIG_PATH="/opt/ffmpeg/share/pkgconfig:/opt/ffmpeg/lib/pkgconfig:/opt/ffmpeg/lib64/pkgconfig"
ARG  PREFIX=/opt/ffmpeg
ARG  LD_LIBRARY_PATH="/opt/ffmpeg/lib:/opt/ffmpeg/lib64"

ARG DEBIAN_FRONTEND=noninteractive

ENV BUILD_DEPS="autoconf \
                automake \
                cmake \
                curl \
                bzip2 \
                libexpat1-dev \
                g++ \
                gcc \
                git \
                gperf \
                libtool \
                make \
                meson \
                nasm \
                perl \
                pkg-config \
                flex \
                bison \
                python \
                libssl-dev \
                yasm \
                libva-dev \
                zlib1g-dev"

RUN apt-get -yqq update &&  \
    apt-get install -yq --no-install-recommends ${BUILD_DEPS}

# libvmaf https://github.com/Netflix/vmaf
RUN if which meson || false; then \
    echo "Building VMAF." && \
    DIR=$(mktemp -d) && cd ${DIR} && \
    curl -sL https://github.com/Netflix/vmaf/archive/v${LIBVMAF_VERSION}.tar.gz | \
    tar -zx --strip-components=1 && \
    cd ${DIR}/libvmaf && \
    meson build --buildtype release --prefix=${PREFIX} && \
    ninja -vC build && \
    ninja -vC build install && \
    mkdir -p ${PREFIX}/share/model/ && \
    cp -r ${DIR}/model/* ${PREFIX}/share/model/ && \
    rm -rf ${DIR}; \
    else \
    echo "VMAF skipped."; \
    fi

# opencore-amr https://sourceforge.net/projects/opencore-amr/
RUN DIR=$(mktemp -d) && cd ${DIR} && \
    curl -sL https://sourceforge.net/projects/opencore-amr/files/opencore-amr/opencore-amr-${OPENCOREAMR_VERSION}.tar.gz/download | \
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
    git clone https://bitbucket.org/multicoreware/x265_git.git ${DIR} -b ${X265_VERSION} --depth 1 && \
    cd build/linux && \
    sed -i "/-DEXTRA_LIB/ s/$/ -DCMAKE_INSTALL_PREFIX=\${PREFIX}/" multilib.sh && \
    sed -i "/^cmake/ s/$/ -DENABLE_CLI=OFF/" multilib.sh && \
    if [ $(uname -m) = "aarch64" ]; then \
    sed -i '/^cmake/ s/$/ -DCMAKE_CXX_FLAGS=\"-fPIC\"/' multilib.sh && \
    sed -i '/^cmake/ s/$/ -DCROSS_COMPILE_ARM=ON/' multilib.sh && \
    sed -i '/^cmake/ s/$/ -DENABLE_ASSEMBLY=OFF/' multilib.sh && \
    sed -i '/^cmake/ s/$/ -DCMAKE_SYSTEM_PROCESSOR=aarch64/' multilib.sh; \
    fi && \
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
    curl -sLo config.guess 'https://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.guess;hb=HEAD' && \
    curl -sLo config.sub 'https://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.sub;hb=HEAD' && \
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
    --enable-vp9-highbitdepth  \
    --enable-pic  \
    --enable-shared  \
    --disable-debug  \
    --disable-examples  \
    --disable-docs  \
    --disable-install-bins &&  \
    make -j $(nproc) &&  \
    make install &&  \
    rm -rf ${DIR}

# libwebp https://developers.google.com/speed/webp/
RUN DIR=$(mktemp -d) && cd ${DIR} && \
    curl -sL https://storage.googleapis.com/downloads.webmproject.org/releases/webp/libwebp-${WEBP_VERSION}.tar.gz | \
    tar -zx --strip-components=1 &&  \
    ./configure --prefix="${PREFIX}" --enable-shared &&  \
    make -j $(nproc) && \
    make install && \
    rm -rf ${DIR}

# libmp3lame http://lame.sourceforge.net/
RUN DIR=$(mktemp -d) && cd ${DIR} && \
    curl -sL https://kent.dl.sourceforge.net/project/lame/lame/$(echo ${LAME_VERSION} | sed -e 's/[^0-9]*\([0-9]*\)[.]\([0-9]*\)[.]\([0-9]*\)\([0-9A-Za-z-]*\)/\1.\2/')/lame-${LAME_VERSION}.tar.gz | \
    tar -zx --strip-components=1 && \
    ./configure --prefix="${PREFIX}" --bindir="${PREFIX}/bin" --enable-shared --enable-nasm --disable-frontend && \
    make -j $(nproc) && \
    make install && \
    rm -rf ${DIR}

# xvid https://www.xvid.com/
RUN DIR=$(mktemp -d) && cd ${DIR} && \
    curl -sL http://downloads.xvid.org/downloads/xvidcore-${XVID_VERSION}.tar.gz | \
    tar -zx --strip-components=1 && \
    cd build/generic && \
    ./configure --prefix="${PREFIX}" --bindir="${PREFIX}/bin" --datadir="${DIR}" && \
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

# libxcb (and supporting libraries) for screen capture https://xcb.freedesktop.org/
RUN DIR=$(mktemp -d) && cd ${DIR} && \
    curl -sL https://www.x.org/archive//individual/util/util-macros-${XORG_MACROS_VERSION}.tar.gz | \
    tar -zx --strip-components=1 && \
    ./configure --srcdir=${DIR} --prefix="${PREFIX}" && \
    make -j $(nproc) && \
    make install && \
    rm -rf ${DIR}

RUN DIR=$(mktemp -d) && cd ${DIR} && \
    curl -sL https://www.x.org/archive/individual/proto/xproto-${XPROTO_VERSION}.tar.gz | \
    tar -zx --strip-components=1 && \
    ./configure --srcdir=${DIR} --prefix="${PREFIX}" && \
    make -j $(nproc) && \
    make install && \
    rm -rf ${DIR}

RUN DIR=$(mktemp -d) && cd ${DIR} && \
    curl -sL https://www.x.org/archive/individual/lib/libXau-${XAU_VERSION}.tar.gz | \
    tar -zx --strip-components=1 && \
    ./configure --srcdir=${DIR} --prefix="${PREFIX}" && \
    make -j $(nproc) && \
    make install && \
    rm -rf ${DIR}

RUN DIR=$(mktemp -d) && cd ${DIR} && \
    curl -sL https://xcb.freedesktop.org/dist/libpthread-stubs-${LIBPTHREAD_STUBS_VERSION}.tar.gz | \
    tar -zx --strip-components=1 && \
    ./configure --prefix="${PREFIX}" && \
    make -j $(nproc) && \
    make install && \
    rm -rf ${DIR}

RUN DIR=$(mktemp -d) && cd ${DIR} && \
    curl -sL https://xcb.freedesktop.org/dist/xcb-proto-${XCBPROTO_VERSION}.tar.gz | \
    tar -zx --strip-components=1 && \
    ACLOCAL_PATH="${PREFIX}/share/aclocal" ./autogen.sh && \
    ./configure --prefix="${PREFIX}" && \
    make -j $(nproc) && \
    make install && \
    rm -rf ${DIR}

RUN DIR=$(mktemp -d) && cd ${DIR} && \
    curl -sL https://xcb.freedesktop.org/dist/libxcb-${LIBXCB_VERSION}.tar.gz | \
    tar -zx --strip-components=1 && \
    ACLOCAL_PATH="${PREFIX}/share/aclocal" ./autogen.sh && \
    ./configure --prefix="${PREFIX}" --disable-static --enable-shared && \
    make -j $(nproc) && \
    make install && \
    rm -rf ${DIR}

# libxml2 - for libbluray
RUN DIR=$(mktemp -d) && cd ${DIR} && \
    curl -sL https://github.com/GNOME/libxml2/archive/refs/tags/v${LIBXML2_VERSION}.tar.gz | \
    tar -xz --strip-components=1 && \
    ./autogen.sh --prefix="${PREFIX}" --with-ftp=no --with-http=no --with-python=no && \
    make -j $(nproc) && \
    make install && \
    rm -rf ${DIR}

# libbluray - Requires libxml, freetype, and fontconfig
RUN DIR=$(mktemp -d) && cd ${DIR} && \
    curl -sL https://download.videolan.org/pub/videolan/libbluray/${LIBBLURAY_VERSION}/libbluray-${LIBBLURAY_VERSION}.tar.bz2 | \
    tar -jx --strip-components=1 && \
    ./configure --prefix="${PREFIX}" --disable-examples --disable-bdjava-jar --disable-static --enable-shared && \
    make -j $(nproc) && \
    make install && \
    rm -rf ${DIR}

# libzmq https://github.com/zeromq/libzmq/
RUN DIR=$(mktemp -d) && cd ${DIR} && \
    curl -sL https://github.com/zeromq/libzmq/archive/v${LIBZMQ_VERSION}.tar.gz | \
    tar -xz --strip-components=1 && \
    ./autogen.sh && \
    ./configure --prefix="${PREFIX}" && \
    make -j $(nproc) && \
    make check && \
    make install && \
    rm -rf ${DIR}

# libsrt https://github.com/Haivision/srt
RUN DIR=$(mktemp -d) && cd ${DIR} && \
    curl -sL https://github.com/Haivision/srt/archive/v${LIBSRT_VERSION}.tar.gz | \
    tar -xz --strip-components=1 && \
    cmake -DCMAKE_INSTALL_PREFIX="${PREFIX}" . && \
    make -j $(nproc) && \
    make install && \
    rm -rf ${DIR}

# libpng
RUN DIR=$(mktemp -d) && cd ${DIR} && \
    git clone https://git.code.sf.net/p/libpng/code ${DIR} -b v${LIBPNG_VERSION} --depth 1 && \
    ./autogen.sh && \
    ./configure --prefix="${PREFIX}" && \
    make -j $(nproc) && \
    make check && \
    make install && \
    rm -rf ${DIR}

# libaribb24
RUN DIR=$(mktemp -d) && cd ${DIR} && \
    curl -sL https://github.com/nkoriyama/aribb24/archive/v${LIBARIBB24_VERSION}.tar.gz | \
    tar -xz --strip-components=1 && \
    autoreconf -fiv && \
    ./configure CFLAGS="-I${PREFIX}/include -fPIC" --prefix="${PREFIX}" && \
    make -j $(nproc) && \
    make install && \
    rm -rf ${DIR}

ENV BUILD_OPTIONS="--disable-debug \
                   --disable-doc \
                   --disable-ffplay \
                   --enable-fontconfig \
                   --enable-gpl \
                   --enable-libaom \
                   --enable-libaribb24 \
                   --enable-libass \
                   --enable-libbluray \
                   --enable-libfdk_aac \
                   --enable-libfreetype \
                   --enable-libkvazaar \
                   --enable-libmp3lame \
                   --enable-libopencore-amrnb \
                   --enable-libopencore-amrwb \
                   --enable-libopenjpeg \
                   --enable-libopus \
                   --enable-libsrt \
                   --enable-libtheora \
                   --enable-libvidstab \
                   --enable-libvmaf \
                   --enable-libvorbis \
                   --enable-libvpx \
                   --enable-libwebp \
                   --enable-libx264 \
                   --enable-libx265 \
                   --enable-libxcb \
                   --enable-libxvid \
                   --enable-libzmq \
                   --enable-nonfree \
                   --enable-openssl \
                   --enable-postproc \
                   --enable-shared \
                   --enable-small \
                   --enable-version3 \
                   --extra-cflags="-I${PREFIX}/include" \
                   --extra-ldflags="-L${PREFIX}/lib" \
                   --extra-libs=-ldl \
                   --extra-libs=-lpthread \
                   --prefix=${PREFIX}"

# ffmpeg https://ffmpeg.org/
RUN  DIR=$(mktemp -d) && cd ${DIR} && \
    curl -sL https://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.bz2 | \
    tar -jx --strip-components=1 && \
    ./configure ${BUILD_OPTIONS} && \
    make -j $(nproc) && \
    make install && \
    make distclean && \
    rm -rf ${DIR}

# cleanup
RUN ldd ${PREFIX}/bin/ffmpeg | grep opt/ffmpeg | cut -d ' ' -f 3 | xargs -i cp {} /usr/local/lib/ && \
    for lib in /usr/local/lib/*.so.*; do ln -s "${lib##*/}" "${lib%%.so.*}".so; done && \
    cp ${PREFIX}/bin/* /usr/local/bin/ && \
    cp -r ${PREFIX}/share/ffmpeg /usr/local/share/ && \
    LD_LIBRARY_PATH=/usr/local/lib ffmpeg -buildconf && \
    cp -r ${PREFIX}/include/libav* ${PREFIX}/include/libpostproc ${PREFIX}/include/libsw* /usr/local/include && \
    mkdir -p /usr/local/lib/pkgconfig && \
    for pc in ${PREFIX}/lib/pkgconfig/libav*.pc ${PREFIX}/lib/pkgconfig/libpostproc.pc ${PREFIX}/lib/pkgconfig/libsw*.pc; do \
      sed "s:${PREFIX}:/usr/local:g" <"$pc" >/usr/local/lib/pkgconfig/"${pc##*/}"; \
    done && \
    hash -r
