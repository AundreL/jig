DOCKER_IMAGE = test-container
DOCKER_VOLUME = './:/app-home/'
#use sudo -s switch to load caller environment

.PHONY: build-all
build-all: clean build-docker build 

.PHONY: build
build: jig.rs
	rustc jig.rs -o binary/jig

.PHONY: build-docker
build-docker: docker/Dockerfile
	docker build -t $(DOCKER_IMAGE) docker
	docker container prune -f
	docker image prune -f

.PHONY: test
test:	
	binary/jig

.PHONY: build-in-container
build-in-container: jig.rs
	mkdir -p binary
	docker run -v $(DOCKER_VOLUME) $(DOCKER_IMAGE) build

.PHONY: test-env
test-env:
	docker run -v $(DOCKER_VOLUME) --entrypoint '/bin/sh' $(DOCKER_IMAGE)  

.PHONY: dry-run
dry-run:
	docker run -it -v $(DOCKER_VOLUME) $(DOCKER_IMAGE)

.PHONY: docker-clean
docker-clean:
	docker container prune -f
	docker image prune -f

.PHONY: clean
clean:
	rm  -rf binary
