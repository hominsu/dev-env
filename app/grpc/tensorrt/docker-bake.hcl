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

variable "TENSORRT_VERSION" {
  default = "22.05-py3"
}

variable "VERSION" {
  default = "grpc-${GRPC_VERSION}-tensorrt-${TENSORRT_VERSION}"
}

group "default" {
  targets = [
    "grpc-tensorrt-runtime",
  ]
}

target "grpc-tensorrt-runtime" {
  contexts = {
    "${REPO}/grpc-tensorrt:grpc-${GRPC_VERSION}-${DEBIAN_VERSION}-devel" = "docker-image://hominsu/grpc-debian:grpc-${GRPC_VERSION}-${DEBIAN_VERSION}-devel"
  }
  dockerfile = "runtime/Dockerfile"
  args       = {
    AUTHOR_NAME      = "${AUTHOR_NAME}"
    AUTHOR_EMAIL     = "${AUTHOR_EMAIL}"
    REPO             = "${REPO}"
    VERSION          = "${VERSION}"
    DEBIAN_VERSION   = "${DEBIAN_VERSION}"
    GRPC_VERSION     = "${GRPC_VERSION}"
    TENSORRT_VERSION = "${TENSORRT_VERSION}"
  }
  tags = [
    "${REPO}/grpc-tensorrt:grpc-${GRPC_VERSION}-tensorrt-${TENSORRT_VERSION}-runtime",
  ]
  platforms = [
    "linux/arm64", "linux/amd64"
  ]
}