variable "REPO" {
  default = "hominsu"
}

variable "AUTHOR_NAME" {
  default = "hominsu"
}

variable "AUTHOR_EMAIL" {
  default = "hominsu@foxmail.com"
}

variable "VERSION" {
  default = "bullseye-slim"
}

variable "DEBIAN_VERSION" {
  default = "bullseye"
}

group "default" {
  targets = [
    "ffmpeg-debian-base",
    "ffmpeg-debian-devel",
    "ffmpeg-debian-runtime",
  ]
}

target "ffmpeg-debian-base" {
  context    = "."
  dockerfile = "base/Dockerfile"
  args       = {
    AUTHOR_NAME    = "${AUTHOR_NAME}"
    AUTHOR_EMAIL   = "${AUTHOR_EMAIL}"
    REPO           = "${REPO}"
    VERSION        = "${VERSION}"
    DEBIAN_VERSION = "${DEBIAN_VERSION}"
  }
  tags = [
    "${REPO}/ffmpeg-debian:${DEBIAN_VERSION}-slim-base",
  ]
  platforms = ["linux/arm64"]
}

target "ffmpeg-debian-devel" {
  contexts = {
    "${REPO}/ffmpeg-debian:${DEBIAN_VERSION}-slim-base" = "target:ffmpeg-debian-base"
  }
  dockerfile = "devel/Dockerfile"
  args       = {
    AUTHOR_NAME    = "${AUTHOR_NAME}"
    AUTHOR_EMAIL   = "${AUTHOR_EMAIL}"
    REPO           = "${REPO}"
    VERSION        = "${VERSION}"
    DEBIAN_VERSION = "${DEBIAN_VERSION}"
  }
  tags = [
    "${REPO}/ffmpeg-debian:${DEBIAN_VERSION}-slim-devel",
  ]
  platforms = ["linux/arm64"]
}

target "ffmpeg-debian-runtime" {
  contexts = {
    "${REPO}/ffmpeg-debian:${DEBIAN_VERSION}-slim-base"  = "target:ffmpeg-debian-base"
    "${REPO}/ffmpeg-debian:${DEBIAN_VERSION}-slim-devel" = "target:ffmpeg-debian-devel"
  }
  dockerfile = "runtime/Dockerfile"
  args       = {
    AUTHOR_NAME    = "${AUTHOR_NAME}"
    AUTHOR_EMAIL   = "${AUTHOR_EMAIL}"
    REPO           = "${REPO}"
    VERSION        = "${VERSION}"
    DEBIAN_VERSION = "${DEBIAN_VERSION}"
  }
  tags = [
    "${REPO}/ffmpeg-debian:${DEBIAN_VERSION}-slim-runtime",
  ]
  platforms = ["linux/arm64"]
}