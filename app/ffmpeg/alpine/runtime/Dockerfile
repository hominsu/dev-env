# syntax=docker/dockerfile:1.4
ARG REPO
ARG ALPINE_VERSION

FROM ${REPO}/ffmpeg-alpine:alpine-${ALPINE_VERSION}-devel as devel
FROM alpine:3.15

# image info
ARG AUTHOR_NAME
ARG AUTHOR_EMAIL
ARG VERSION

# label
LABEL author=${AUTHOR_NAME} email=${AUTHOR_EMAIL} version=${VERSION}

COPY --from=devel /tmp/fakeroot/bin /usr/local/bin
COPY --from=devel /tmp/fakeroot/share /usr/local/share
COPY --from=devel /tmp/fakeroot/include /usr/local/include
COPY --from=devel /tmp/fakeroot/lib /usr/local/lib
