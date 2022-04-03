.PHONY: docker
# generate docker
docker:
	find app -mindepth 3 -maxdepth 3 -type d -print | sort | xargs -L 1 bash -c 'cd "$$0" && pwd && $(MAKE) docker'

.PHONY: buildx
# generate buildx
buildx:
	find app -mindepth 3 -maxdepth 3 -type d -print | sort | xargs -L 1 bash -c 'cd "$$0" && pwd && $(MAKE) buildx'

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
