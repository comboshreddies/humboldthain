#!/bin/bash
USERNAME=comboshreddies
GHCRPASS=$PASSWORD


cd utils/gke_k8s
VERSION=$(cat version)
DOCKER_TAG="gke_k8s:${VERSION}"

docker login ghcr.io -u $USERNAME -p $GHCRPASS

docker build . -t  ghcr.io/${USERNAME}/${DOCKER_TAG}
docker push ghcr.io/${USERNAME}/${DOCKER_TAG}
docker images | grep ${USERNAME}

