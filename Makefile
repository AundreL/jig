DOCKER_IMAGE_ALPINE = jig-alpine
DOCKER_IMAGE_DEBIAN = jig-debian

.PHONY: sandbox-deb
sandbox-deb: #start docker debian container terminal
	docker run --entrypoint /bin/sh -it $(DOCKER_IMAGE_DEBIAN)

.PHONY: sandbox-alp
sandbox-alp: #start docker alpine container terminal
	docker run --entrypoint /bin/sh -it $(DOCKER_IMAGE_ALPINE) 

.PHONY: base-build-docker
base-build-docker: docker/Dockerfile.ctalpine docker/Dockerfile.ctdebian
	docker build -t $(DOCKER_IMAGE_ALPINE) -f ./docker/Dockerfile.ctalpine .
	docker build -t $(DOCKER_IMAGE_DEBIAN) -f ./docker/Dockerfile.ctdebian .

.PHONY: build-docker
build-docker: clean-docker base-build-docker #build docker images

.PHONY: clean-docker
clean-docker:
	#clean up dangling containers and images
	docker container prune -f
	docker image prune -f

.PHONY: unit-test
unit-test: main.go
	go test -v ./pkg/jig

default: help

.PHONY: help
help: #jig make file commands
	@grep -E '^[a-za-z0-9 -]+:.*#'  Makefile | sort | while read -r l; do printf "\033[1;32m$$(echo $$l | cut -f 1 -d':')\033[00m: $$(echo $$l | cut -f 2- -d'#')\n"; done
