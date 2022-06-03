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
  default = "alpine-3.16"
}

variable "ALPINE_VERSION" {
  default = "3.16"
}

variable "GRPC_VERSION" {
  default = "1.46.3"
}

group "default" {
  targets = [
    "grpc-alpine-alpine",
    "grpc-alpine-deps",
    "grpc-alpine-devel",
    "grpc-alpine-runtime",
  ]
}

target "grpc-alpine-alpine" {
  context    = "./alpine"
  dockerfile = "Dockerfile"
  args       = {
    AUTHOR_NAME    = "${AUTHOR_NAME}"
    AUTHOR_EMAIL   = "${AUTHOR_EMAIL}"
    REPO           = "${REPO}"
    VERSION        = "${VERSION}"
    ALPINE_VERSION = "${ALPINE_VERSION}"
    GRPC_VERSION   = "${GRPC_VERSION}"
  }
  tags = [
    "${REPO}/grpc-alpine:grpc-${GRPC_VERSION}-alpine-${ALPINE_VERSION}-alpine",
  ]
  platforms = [
    "linux/arm64", "linux/amd64", "linux/arm"
  ]
}

target "grpc-alpine-deps" {
  context    = "./deps"
  dockerfile = "Dockerfile"
  args       = {
    AUTHOR_NAME    = "${AUTHOR_NAME}"
    AUTHOR_EMAIL   = "${AUTHOR_EMAIL}"
    REPO           = "${REPO}"
    VERSION        = "${VERSION}"
    ALPINE_VERSION = "${ALPINE_VERSION}"
    GRPC_VERSION   = "${GRPC_VERSION}"
  }
  tags = [
    "${REPO}/grpc-alpine:grpc-${GRPC_VERSION}-alpine-${ALPINE_VERSION}-deps",
  ]
  platforms = [
    "linux/arm64", "linux/amd64", "linux/arm"
  ]
}

target "grpc-alpine-devel" {
  contexts = {
    "${REPO}/grpc-alpine:grpc-${GRPC_VERSION}-alpine-${ALPINE_VERSION}-deps" = "target:grpc-alpine-deps"
  }
  context    = "./devel"
  dockerfile = "Dockerfile"
  args       = {
    AUTHOR_NAME    = "${AUTHOR_NAME}"
    AUTHOR_EMAIL   = "${AUTHOR_EMAIL}"
    REPO           = "${REPO}"
    VERSION        = "${VERSION}"
    ALPINE_VERSION = "${ALPINE_VERSION}"
    GRPC_VERSION   = "${GRPC_VERSION}"
  }
  tags = [
    "${REPO}/grpc-alpine:grpc-${GRPC_VERSION}-alpine-${ALPINE_VERSION}-devel",
  ]
  platforms = [
    "linux/arm64", "linux/amd64", "linux/arm"
  ]
}

target "grpc-alpine-runtime" {
  contexts = {
    "${REPO}/grpc-alpine:grpc-${GRPC_VERSION}-alpine-${ALPINE_VERSION}-deps" = "target:grpc-alpine-deps"
    "${REPO}/grpc-alpine:grpc-${GRPC_VERSION}-alpine-${ALPINE_VERSION}-devel" = "target:grpc-alpine-devel"
  }
  dockerfile = "runtime/Dockerfile"
  args       = {
    AUTHOR_NAME    = "${AUTHOR_NAME}"
    AUTHOR_EMAIL   = "${AUTHOR_EMAIL}"
    REPO           = "${REPO}"
    VERSION        = "${VERSION}"
    ALPINE_VERSION = "${ALPINE_VERSION}"
    GRPC_VERSION   = "${GRPC_VERSION}"
  }
  tags = [
    "${REPO}/grpc-alpine:grpc-${GRPC_VERSION}-alpine-${ALPINE_VERSION}-runtime",
  ]
  platforms = [
    "linux/arm64", "linux/amd64", "linux/arm"
  ]
}