#!/bin/bash
USERNAME=comboshreddies
GHCRPASS=$PASSWORD

VERSION=$(cat utils/gke_k8s/version)
DOCKER_TAG="gke_k8s:${VERSION}"
FULL_DOCKER="ghcr.io/${USERNAME}/${DOCKER_TAG}"

docker login ghcr.io -u "$USERNAME" -p "$GHCRPASS"

if [ "$1" == "create" ] ; then 
   docker run --rm -e GKE_TGZ_PASS="${GKE_TGZ_PASS}" \
	   -v ${PWD}/manifests:/manifests ${FULL_DOCKER} \
	   /manifests/scripts/create.sh
fi

if [ "$1" == "delete" ] ; then 
   docker run --rm -e GKE_TGZ_PASS="${GKE_TGZ_PASS}" \
           -v ${PWD}/manifests:/manifests ${FULL_DOCKER} \
	   /manifests/scripts/delete.sh
fi

if [ "$1" == "k8s_deploy" ] ; then 
   docker run --rm -e GKE_TGZ_PASS="${GKE_TGZ_PASS}" \
	   -v ${PWD}/manifests:/manifests ${FULL_DOCKER} \
	   /manifests/scripts/k8s.sh deploy
fi

if [ "$1" == "k8s_delete" ] ; then 
   docker run --rm -e GKE_TGZ_PASS="${GKE_TGZ_PASS}" \
	   -v ${PWD}/manifests:/manifests ${FULL_DOCKER} \
	   /manifests/scripts/k8s.sh delete
fi

if [ "$1" == "k8s_getAll" ] ; then 
   docker run --rm -e GKE_TGZ_PASS="${GKE_TGZ_PASS}" \
	   -v ${PWD}/manifests:/manifests ${FULL_DOCKER} \
	   /manifests/scripts/k8s.sh getAll
fi


