# syntax=docker/dockerfile:1.4
ARG REPO
ARG ALPINE_VERSION
ARG FFMPEG_VERSION

FROM ${REPO}/ffmpeg-alpine:ffmpeg-${FFMPEG_VERSION}-alpine-${ALPINE_VERSION}-devel as devel
FROM alpine:${ALPINE_VERSION}

# image info
ARG AUTHOR_NAME
ARG AUTHOR_EMAIL
ARG VERSION
ARG ALPINE_VERSION
ARG FFMPEG_VERSION

# label
LABEL author=${AUTHOR_NAME} email=${AUTHOR_EMAIL} version=${VERSION} alpine_version=${ALPINE_VERSION} ffmpeg_version=${FFMPEG_VERSION}

COPY --from=devel /tmp/fakeroot/bin /usr/local/bin
COPY --from=devel /tmp/fakeroot/share /usr/local/share
COPY --from=devel /tmp/fakeroot/include /usr/local/include
COPY --from=devel /tmp/fakeroot/lib /usr/local/lib
