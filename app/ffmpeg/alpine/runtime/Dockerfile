FROM hominsu/ffmpeg-alpine:devel as devel
FROM alpine:3.15

COPY --from=devel /tmp/fakeroot/bin /usr/local/bin
COPY --from=devel /tmp/fakeroot/share /usr/local/share
COPY --from=devel /tmp/fakeroot/include /usr/local/include
COPY --from=devel /tmp/fakeroot/lib /usr/local/lib
