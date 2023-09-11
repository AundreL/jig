
#use sudo -s switch to load caller environment

.PHONY: build-all
build-all: build build-docker

.PHONY: build
build: jig.go
	go build -o binary/jig

.PHONY: build-docker
build-docker: docker/Dockerfile
	docker build -t test-container docker
	docker container prune -f
	docker image prune -f

.PHONY: test
test:	
	#testing
	binary/jig

.PHONY: test-env
test-env:
	docker run -it -v './:/app-home' --entrypoint '/bin/sh' test-container 

.PHONY: dry-run
dry-run:
	docker run -v './:/app-home' test-container

.PHONY: clean
clean:
	rm  -rf binary
