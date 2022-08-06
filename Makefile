PROJECT_NAME := humboldthain
GO := go
GITHUB_HASH := $(shell git rev-parse HEAD)
GO_FILE := go03
VERSION := $(shell cat version)
GIN_MODE := "debug" # debug, test or release
DOCKER_TAG := ${PROJECT_NAME}-${GO_FILE}:${VERSION}
GO_DIR := "go_pkg"

.PHONY: build-local-bin cleani deps-clean mr-proper docker-image \
	check-docker-image go-get-gin

build-local-bin:
	docker run --rm \
	  -u $$(id -u):$$(id -g) \
	  -e GOPATH="/src/${GO_DIR}" \
	  -e GOCACHE="/src/${GO_DIR}/.cache" \
	  -v /etc/localtime:/etc/localtime:ro \
	  -v ${PWD}/:/src \
	  -w /src \
	  golang \
	  make go-make-${GO_FILE}

${GO_FILE}: build-local-bin

clean:
	rm -f ${GO_FILE}

deps-clean:
	rm -f go.sum go.mod

vendor-clean:
	rm -rf vendor

mr-proper: clean deps-clean vendor-clean docker-clean
	chmod u+w -R go_pkg || true
	rm -rf go_pkg
	mkdir go_pkg

go-make-${GO_FILE}: go-build-${GO_FILE}

go-build-${GO_FILE}: go-make-deps ${GO_FILE}.go
	CGO_ENABLED=0 ${GO} build ${GO_FILE}.go

go-make-deps: go.mod go-get-testify go-get-gin

go.mod:
	( ${GO} mod init ${PROJECT_NAME} || true )

go-get-gin:
	@( ${GO} list -m -u github.com/gin-gonic/gin || ${GO} get -u github.com/gin-gonic/gin )

go-get-testify:
	@( ${GO} list -m -u github.com/stretchr/testify || ${GO} get -u github.com/stretchr/testify )

test:
	docker run --rm \
	  -u $$(id -u):$$(id -g) \
	  -e GOPATH="/src/${GO_DIR}" \
	  -e GOCACHE="/src/${GO_DIR}/.cache" \
	  -v /etc/localtime:/etc/localtime:ro \
	  -v ${PWD}/:/src \
	  -w /src \
	  golang \
	  /bin/bash -c "export GITHUB_HASH=abcd && \
	      export PROJECT_NAME="test123" && \
	      export GIN_MODE="debug" && \
	      ${GO} test"

docker-image: ${GO_FILE}
	docker build \
	  --build-arg BIN=${GO_FILE} \
	  --build-arg GITHUB_HASH=${GITHUB_HASH} \
	  --build-arg PROJECT_NAME=${PROJECT_NAME} \
	  --build-arg VERSION=${VERSION} \
	  --build-arg GIN_MODE=${GIN_MODE} \
	  -t ${DOCKER_TAG} .

${GO_FILE}: build-local-bin

local-run: ${GO_FILE}
	./${GO_FILE}

docker-run: check-docker-image
	docker run -p 8080:8080 --rm ${DOCKER_TAG}

docker-run-release: check-docker-image
	docker run -d -p 8080:8080 --rm -e GIN_MODE=release --name ${PROJECT_NAME}-${GO_FILE} ${DOCKER_TAG}

docker-stop-release:
	docker stop ${PROJECT_NAME}-${GO_FILE}

docker-test:
	./docker-test.sh

docker-clean: 
	docker image rm -f ${DOCKER_TAG}

check-docker-image:
	docker image ls ${DOCKER_TAG} --format='{{.Repository }}:{{.Tag}}' | grep -c ${DOCKER_TAG} || make docker-image

