ALPINE_DOCKER_NAME=yappi-alpine

build-alpine-container:
	docker build . -f Dockerfile.alpine -t $(ALPINE_DOCKER_NAME)

run: build-alpine-container
	-docker rm $(ALPINE_DOCKER_NAME)
	docker run --name $(ALPINE_DOCKER_NAME) $(ALPINE_DOCKER_NAME)

sh:
	docker exec -it $(ALPINE_DOCKER_NAME) sh

copy-wheel-to-host:
	docker cp $(ALPINE_DOCKER_NAME):/usr/src/build/wheels .tmp-wheels-from-alpine
	rename linux alpine-linux .tmp-wheels-from-alpine/yappi-*.whl
	mkdir -p wheels/
	cp .tmp-wheels-from-alpine/yappi-*.whl wheels/
	rm -rf .tmp-wheels-from-alpine

local-setup:
	pip install wheel

local-build-wheel:
	pip wheel -w wheel -e .
