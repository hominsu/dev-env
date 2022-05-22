# syntax=docker/dockerfile:1.4
ARG REPO
ARG DEBIAN_VERSION

FROM ${REPO}/ffmpeg-debian:${DEBIAN_VERSION}-slim-devel as devel
FROM ${REPO}/ffmpeg-debian:${DEBIAN_VERSION}-slim-base

# image info
ARG AUTHOR_NAME
ARG AUTHOR_EMAIL
ARG VERSION

# label
LABEL author=${AUTHOR_NAME} email=${AUTHOR_EMAIL} version=${VERSION}

COPY --from=devel /usr/local /usr/local/
COPY --from=devel /opt/ffmpeg/lib/pkgconfig /usr/local/lib/pkgconfig

ENV LD_LIBRARY_PATH=/usr/local/lib
ENV PKG_CONFIG_PATH=/usr/local/lib/pkgconfig
