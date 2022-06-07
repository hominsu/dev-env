variable "REPO" {
  default = "hominsu"
}

variable "AUTHOR_NAME" {
  default = "hominsu"
}

variable "AUTHOR_EMAIL" {
  default = "hominsu@foxmail.com"
}

variable "DEBIAN_VERSION" {
  default = "bullseye-slim"
}

variable "GRPC_VERSION" {
  default = "1.46.3"
}

variable "VERSION" {
  default = "grpc-${GRPC_VERSION}-${DEBIAN_VERSION}"
}

group "default" {
  targets = [
    "grpc-debian-deps",
    "grpc-debian-devel",
    "grpc-debian-runtime",
  ]
}

target "grpc-debian-deps" {
  context    = "./deps"
  dockerfile = "Dockerfile"
  args       = {
    AUTHOR_NAME    = "${AUTHOR_NAME}"
    AUTHOR_EMAIL   = "${AUTHOR_EMAIL}"
    REPO           = "${REPO}"
    VERSION        = "${VERSION}"
    DEBIAN_VERSION = "${DEBIAN_VERSION}"
    GRPC_VERSION   = "${GRPC_VERSION}"
  }
  tags = [
    "${REPO}/grpc-debian:grpc-${GRPC_VERSION}-${DEBIAN_VERSION}-deps",
  ]
  platforms = [
    "linux/arm64", "linux/amd64", "linux/arm"
  ]
}

target "grpc-debian-devel" {
  contexts = {
    "${REPO}/grpc-debian:grpc-${GRPC_VERSION}-${DEBIAN_VERSION}-deps" = "target:grpc-debian-deps"
  }
  context    = "./devel"
  dockerfile = "Dockerfile"
  args       = {
    AUTHOR_NAME    = "${AUTHOR_NAME}"
    AUTHOR_EMAIL   = "${AUTHOR_EMAIL}"
    REPO           = "${REPO}"
    VERSION        = "${VERSION}"
    DEBIAN_VERSION = "${DEBIAN_VERSION}"
    GRPC_VERSION   = "${GRPC_VERSION}"
  }
  tags = [
    "${REPO}/grpc-debian:grpc-${GRPC_VERSION}-${DEBIAN_VERSION}-devel",
  ]
  platforms = [
    "linux/arm64", "linux/amd64", "linux/arm"
  ]
}

target "grpc-debian-runtime" {
  contexts = {
    "${REPO}/grpc-debian:grpc-${GRPC_VERSION}-${DEBIAN_VERSION}-deps" = "target:grpc-debian-deps"
    "${REPO}/grpc-debian:grpc-${GRPC_VERSION}-${DEBIAN_VERSION}-devel" = "target:grpc-debian-devel"
  }
  dockerfile = "runtime/Dockerfile"
  args       = {
    AUTHOR_NAME    = "${AUTHOR_NAME}"
    AUTHOR_EMAIL   = "${AUTHOR_EMAIL}"
    REPO           = "${REPO}"
    VERSION        = "${VERSION}"
    DEBIAN_VERSION = "${DEBIAN_VERSION}"
    GRPC_VERSION   = "${GRPC_VERSION}"
  }
  tags = [
    "${REPO}/grpc-debian:grpc-${GRPC_VERSION}-${DEBIAN_VERSION}-runtime",
  ]
  platforms = [
    "linux/arm64", "linux/amd64", "linux/arm"
  ]
}