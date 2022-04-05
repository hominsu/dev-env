.PHONY: ffmpeg-alpine
# build ffmpeg-alpine images for current platform via docker
ffmpeg-alpine:
	find app/ffmpeg/alpine -mindepth 1 -maxdepth 1 -type d -print | sort | xargs -L 1 bash -c 'cd "$$0" && pwd && $(MAKE) ffmpeg-alpine'

.PHONY: ffmpeg-alpine-buildx
# build ffmpeg-alpine images for multi-platform via buildx
ffmpeg-alpine-buildx:
	find app/ffmpeg/alpine -mindepth 1 -maxdepth 1 -type d -print | sort | xargs -L 1 bash -c 'cd "$$0" && pwd && $(MAKE) ffmpeg-alpine-buildx'

.PHONY: all
# build all images for current platform via docker
all-docker: ffmpeg-alpine

.PHONY: all-buildx
# build all images for multi-platform via buildx
all-buildx: ffmpeg-alpine-buildx

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
