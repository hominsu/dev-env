.PHONY: ffmpeg-docker
# build ffmpeg images for current platform via docker
ffmpeg-docker:
	find app/ffmpeg -mindepth 2 -maxdepth 2 -type d -print | sort | xargs -L 1 bash -c 'cd "$$0" && pwd && $(MAKE) docker'

.PHONY: ffmpeg-buildx
# build ffmpeg images for multi-platform via buildx
ffmpeg-buildx:
	find app/ffmpeg -mindepth 2 -maxdepth 2 -type d -print | sort | xargs -L 1 bash -c 'cd "$$0" && pwd && $(MAKE) buildx'

.PHONY: all-docker
# build all images for current platform via docker
all-docker: ffmpeg-docker

.PHONY: all-buildx
# build all images for multi-platform via buildx
all-buildx: ffmpeg-buildx

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
