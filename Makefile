
#use sudo -s switch to load caller environment
.PHONY: build
build: jig.go
	go build -o binary/jig

.PHONY: test
test:
	echo test not implemented

.PHONY: clean
clean:
	rm  -rf binary
