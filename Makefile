DOCKER_IMAGE_ALPINE = alpine-env
DOCKER_IMAGE_DEBIAN= debian-env 
DOCKER_VOLUME = './:/jig-test-env/'
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

.PHONY: quick-test
quick-test: #test using cached mock data not going online
	QUICK_FLAG=1
	$(info $(QUICK_FLAG))
	
	cargo test

.PHONY: base-build-docker
base-build-docker: docker/Dockerfile.ctalpine docker/Dockerfile.ctdebian
	docker build -t $(DOCKER_IMAGE_ALPINE) -f ./docker/Dockerfile.ctalpine .
	docker build -t $(DOCKER_IMAGE_DEBIAN) -f ./docker/Dockerfile.ctdebian . 

.PHONY: build-docker
build-docker: base-build-docker docker-clean 

.PHONY: prep-env
prep-env:
	set -x PATH target/debug $PATH

.PHONY: run-deb
run-deb: #start docker debian container terminal
	docker run --entrypoint /bin/sh -it debian-env

.PHONY: run-alp
run-alp: #start docker alpine container terminal
	docker run --entrypoint /bin/sh -it alpine-env

.PHONY: build-in-container
build-in-container: jig.rs
	docker run -v $(DOCKER_VOLUME) $(DOCKER_IMAGE) build

.PHONY: test-env
test-env:
	docker run -v $(DOCKER_VOLUME) --entrypoint '/bin/sh' $(DOCKER_IMAGE)  

.PHONY: dry-run
dry-run:
	docker run -it -v $(DOCKER_VOLUME) $(DOCKER_IMAGE)

.PHONY: docker-clean
docker-clean:
	#clean up dangling containers and images
	docker container prune -f
	docker image prune -f

.PHONY: clean
clean:
	rm  -rf target
