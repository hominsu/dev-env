variable "REPO" {
  default = "hominsu"
}

variable "AUTHOR_NAME" {
  default = "hominsu"
}

variable "AUTHOR_EMAIL" {
  default = "hominsu@foxmail.com"
}

variable "ALPINE_VERSION" {
  default = "3.15"
}

variable "FFMPEG_VERSION" {
  default = "5.0.1"
}

variable "VERSION" {
  default = "ffmpeg-${FFMPEG_VERSION}-alpine-${ALPINE_VERSION}"
}

group "default" {
  targets = [
    "ffmpeg-alpine-alpine",
    "ffmpeg-alpine-deps",
    "ffmpeg-alpine-devel",
    "ffmpeg-alpine-runtime",
  ]
}

target "ffmpeg-alpine-alpine" {
  context    = "."
  dockerfile = "alpine/Dockerfile"
  args       = {
    AUTHOR_NAME    = "${AUTHOR_NAME}"
    AUTHOR_EMAIL   = "${AUTHOR_EMAIL}"
    REPO           = "${REPO}"
    VERSION        = "${VERSION}"
    ALPINE_VERSION = "${ALPINE_VERSION}"
    FFMPEG_VERSION = "${FFMPEG_VERSION}"
  }
  tags = [
    "${REPO}/ffmpeg-alpine:ffmpeg-${FFMPEG_VERSION}-alpine-${ALPINE_VERSION}-alpine",
  ]
  platforms = ["linux/arm64", "linux/amd64"]
}

target "ffmpeg-alpine-deps" {
  context    = "."
  dockerfile = "deps/Dockerfile"
  args       = {
    AUTHOR_NAME    = "${AUTHOR_NAME}"
    AUTHOR_EMAIL   = "${AUTHOR_EMAIL}"
    REPO           = "${REPO}"
    VERSION        = "${VERSION}"
    ALPINE_VERSION = "${ALPINE_VERSION}"
    FFMPEG_VERSION = "${FFMPEG_VERSION}"
  }
  tags = [
    "${REPO}/ffmpeg-alpine:ffmpeg-${FFMPEG_VERSION}-alpine-${ALPINE_VERSION}-deps",
  ]
  platforms = ["linux/arm64", "linux/amd64"]
}

target "ffmpeg-alpine-devel" {
  contexts = {
    "${REPO}/ffmpeg-alpine:ffmpeg-${FFMPEG_VERSION}-alpine-${ALPINE_VERSION}-deps" = "target:ffmpeg-alpine-deps"
  }
  dockerfile = "devel/Dockerfile"
  args       = {
    AUTHOR_NAME    = "${AUTHOR_NAME}"
    AUTHOR_EMAIL   = "${AUTHOR_EMAIL}"
    REPO           = "${REPO}"
    VERSION        = "${VERSION}"
    ALPINE_VERSION = "${ALPINE_VERSION}"
    FFMPEG_VERSION = "${FFMPEG_VERSION}"
  }
  tags = [
    "${REPO}/ffmpeg-alpine:ffmpeg-${FFMPEG_VERSION}-alpine-${ALPINE_VERSION}-devel",
  ]
  platforms = ["linux/arm64", "linux/amd64"]
}

target "ffmpeg-alpine-runtime" {
  contexts = {
    "${REPO}/ffmpeg-alpine:ffmpeg-${FFMPEG_VERSION}-alpine-${ALPINE_VERSION}-deps"  = "target:ffmpeg-alpine-deps"
    "${REPO}/ffmpeg-alpine:ffmpeg-${FFMPEG_VERSION}-alpine-${ALPINE_VERSION}-devel" = "target:ffmpeg-alpine-devel"
  }
  dockerfile = "runtime/Dockerfile"
  args       = {
    AUTHOR_NAME    = "${AUTHOR_NAME}"
    AUTHOR_EMAIL   = "${AUTHOR_EMAIL}"
    REPO           = "${REPO}"
    VERSION        = "${VERSION}"
    ALPINE_VERSION = "${ALPINE_VERSION}"
    FFMPEG_VERSION = "${FFMPEG_VERSION}"
  }
  tags = [
    "${REPO}/ffmpeg-alpine:ffmpeg-${FFMPEG_VERSION}-alpine-${ALPINE_VERSION}-runtime",
  ]
  platforms = ["linux/arm64", "linux/amd64"]
}