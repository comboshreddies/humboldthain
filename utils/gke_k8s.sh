#!/bin/bash
USERNAME=comboshreddies
GHCRPASS=$PASSWORD

cd utils/gke_k8s
VERSION=$(cat version)
DOCKER_TAG="gke_k8s:${VERSION}"

docker login ghcr.io -u $USERNAME -p $GHCRPASS

if [ "$1" == "create" ] ; then 
   docker run -it --rm -e GKE_TGZ_PASS="${GKE_TGZ_PASS}"  ghcr.io/${USERNAME}/${DOCKER_TAG} /root/create.sh
fi

if [ "$1" == "delete" ] ; then 
   docker run -it --rm -e GKE_TGZ_PASS="${GKE_TGZ_PASS}"  ghcr.io/${USERNAME}/${DOCKER_TAG} /root/delete.sh
fi


