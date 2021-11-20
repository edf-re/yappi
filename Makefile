ALPINE_DOCKER_NAME=yappi-alpine-cp38-cp39-cp310
TMP_WHEELS_DIR=.tmp-wheels-from-alpine

build-alpine-wheels:
	docker build . -f Dockerfile.alpine -t $(ALPINE_DOCKER_NAME)

run-alpine-wheels: build-alpine-wheels
	# Use this command to start the container.
	# You can then run a shell in it for debugging.
	-docker rm $(ALPINE_DOCKER_NAME)
	docker run --name $(ALPINE_DOCKER_NAME) $(ALPINE_DOCKER_NAME)

sh:
	# To use this command, please uncomment the CMD line at the bottom
	# of the Dockerfile
	docker exec -it $(ALPINE_DOCKER_NAME) sh

copy-alpine-wheels-to-host: build-alpine-wheels
	rm -rf $(TMP_WHEELS_DIR)
	docker cp $(shell docker create $(ALPINE_DOCKER_NAME)):/usr/wheels/ $(TMP_WHEELS_DIR)
	rename linux alpine-linux $(TMP_WHEELS_DIR)/yappi-*.whl
	mkdir -p wheels/
	cp $(TMP_WHEELS_DIR)/yappi-*.whl wheels/
	rm -rf $(TMP_WHEELS_DIR)

local-setup:
	pip install wheel

local-build-wheel:
	pip wheel -w wheel -e .
