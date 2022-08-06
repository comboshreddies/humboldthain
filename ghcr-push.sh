#!/bin/bash
USERNAME=comboshreddies
GHCRPASS=$PASSWORD


PROJECT_NAME=$(make project-name)
GO_FILE=$(make go-file)
DOCKER_TAG=$(make docker-tag)

DOCKER_NAME=${PROJECT_NAME}-${GO_FILE}

env

docker images

docker login ghcr.io -u $USERNAME -p $GHCRPASS


