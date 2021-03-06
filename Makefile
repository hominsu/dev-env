.PHONY: ffmpeg-alpine
# build ffmpeg-alpine images for current platform via docker
ffmpeg-alpine:
	find app/ffmpeg/alpine -mindepth 1 -maxdepth 1 -type d -print | sort | xargs -L 1 bash -c 'cd "$$0" && pwd && $(MAKE) ffmpeg-alpine'

.PHONY: ffmpeg-alpine-bake
# build ffmpeg-alpine images for multi-platform via buildx bake
ffmpeg-alpine-bake:
	cd app/ffmpeg/alpine && \
	docker buildx bake --file docker-bake.hcl --load

.PHONY: ffmpeg-alpine-push
# build ffmpeg-alpine images for multi-platform via buildx bake and push to the container registry
ffmpeg-alpine-push:
	cd app/ffmpeg/alpine && \
	docker buildx bake --file docker-bake.hcl --push

.PHONY: ffmpeg-debian
# build ffmpeg-debian images for current platform via docker
ffmpeg-debian:
	find app/ffmpeg/debian -mindepth 1 -maxdepth 1 -type d -print | sort | xargs -L 1 bash -c 'cd "$$0" && pwd && $(MAKE) ffmpeg-debian'

.PHONY: ffmpeg-debian-bake
# build ffmpeg-debian images for multi-platform via buildx bake
ffmpeg-debian-bake:
	cd app/ffmpeg/debian && \
	docker buildx bake --file docker-bake.hcl --load

.PHONY: ffmpeg-debian-push
# build ffmpeg-debian images for multi-platform via buildx bake and push to the container registry
ffmpeg-debian-push:
	cd app/ffmpeg/debian && \
	docker buildx bake --file docker-bake.hcl --push

.PHONY: grpc-alpine
# build grpc-alpine images for current platform via docker
grpc-alpine:
	find app/grpc/alpine -mindepth 1 -maxdepth 1 -type d -print | sort | xargs -L 1 bash -c 'cd "$$0" && pwd && $(MAKE) grpc-alpine'

.PHONY: grpc-alpine-bake
# build grpc-alpine images for multi-platform via buildx bake
grpc-alpine-bake:
	cd app/grpc/alpine && \
	docker buildx bake --file docker-bake.hcl --load

.PHONY: grpc-alpine-push
# build grpc-alpine images for multi-platform via buildx bake and push to the container registry
grpc-alpine-push:
	cd app/grpc/alpine && \
	docker buildx bake --file docker-bake.hcl --push

.PHONY: grpc-debian
# build grpc-debian images for current platform via docker
grpc-debian:
	find app/grpc/debian -mindepth 1 -maxdepth 1 -type d -print | sort | xargs -L 1 bash -c 'cd "$$0" && pwd && $(MAKE) grpc-debian'

.PHONY: grpc-debian-bake
# build grpc-debian images for multi-platform via buildx bake
grpc-debian-bake:
	cd app/grpc/debian && \
	docker buildx bake --file docker-bake.hcl --load

.PHONY: grpc-debian-push
# build grpc-debian images for multi-platform via buildx bake and push to the container registry
grpc-debian-push:
	cd app/grpc/debian && \
	docker buildx bake --file docker-bake.hcl --push

.PHONY: all
# build all images for current platform via docker
all-docker: ffmpeg-alpine ffmpeg-debian grpc-alpine grpc-debian

.PHONY: all-bake
# build all images for multi-platform via buildx bake
all-bake: ffmpeg-alpine-bake ffmpeg-debian-bake grpc-alpine-bake grpc-debian-bake

.PHONY: all-push
# build all images for multi-platform via buildx bake and push to the container registry
all-push: ffmpeg-alpine-push ffmpeg-debian-push grpc-alpine-push grpc-debian-push

# show help
help:
	@echo ''
	@echo 'Usage:'
	@echo ' make [target]'
	@echo ''
	@echo 'Targets:'
	@awk '/^[a-zA-Z\-\_0-9]+:/ { \
	helpMessage = match(lastLine, /^# (.*)/); \
		if (helpMessage) { \
			helpCommand = substr($$1, 0, index($$1, ":")-1); \
			helpMessage = substr(lastLine, RSTART + 2, RLENGTH); \
			printf "\033[36m%-22s\033[0m %s\n", helpCommand,helpMessage; \
		} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help
