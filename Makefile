DOCKER_IMAGE_ALPINE = jig-alpine
DOCKER_IMAGE_DEBIAN = jig-debian
MOCK_LOCATION := $(realpath ./test/mock-data)
DOCKER_VOLUME := $(realpath ./.volume-cache)
#use sudo -s switch to load caller environment

default: help

.PHONY: help
help: #jig make file commands
	@grep -E '^[a-za-z0-9 -]+:.*#'  Makefile | sort | while read -r l; do printf "\033[1;32m$$(echo $$l | cut -f 1 -d':')\033[00m: $$(echo $$l | cut -f 2- -d'#')\n"; done

.PHONY: build-all 
build-all: clean build-docker build #clean build

.PHONY: build
build: jig.rs #build only jig executable
	cargo build

.PHONY: test
test: #test jig
	QUICK_FLAG=0
	$(info $(QUICK_FLAG))
	cargo test

.PHONY: unit-test
unit-test: load-volume#do unit tests on mock data
	docker run -v $(DOCKER_VOLUME):/app-home:ro -it --entrypoint '/bin/sh' $(DOCKER_IMAGE_DEBIAN)

.PHONY: prep-env
prep-env:
	set -x PATH target/debug $PATH

.PHONY: run-deb
run-deb: #start docker debian container terminal
	docker run --entrypoint /bin/sh -it $(DOCKER_IMAGE_DEBIAN)

.PHONY: run-alp
run-alp: #start docker alpine container terminal
	docker run --entrypoint /bin/sh -it $(DOCKER_IMAGE_ALPINE) 


.PHONY: test-env
test-env:
	docker run -it --entrypoint '/bin/sh' $(DOCKER_IMAGE_DEBIAN)  

.PHONY: dry-run
dry-run:
	docker run -it -v $(DOCKER_VOLUME) $(DOCKER_IMAGE)

.PHONY: base-build-docker
base-build-docker: docker/Dockerfile.ctalpine docker/Dockerfile.ctdebian
	docker build -t $(DOCKER_IMAGE_ALPINE) -f ./docker/Dockerfile.ctalpine .
	docker build -t $(DOCKER_IMAGE_DEBIAN) -f ./docker/Dockerfile.ctdebian . 

.PHONY: build-docker
build-docker: clean-docker base-build-docker #build docker images

load-volume: 
	mkdir -p $(DOCKER_VOLUME) 
	cp -r $(MOCK_LOCATION) $(DOCKER_VOLUME)

.PHONY: clean-docker
clean-docker:
	#clean up dangling containers and images
	docker container prune -f
	docker image prune -f

.PHONY: clean-cache
clean-cache:
	rm -rf ./cache
	mkdir ./cache

.PHONY: clean
clean:
	rm  -rf target
