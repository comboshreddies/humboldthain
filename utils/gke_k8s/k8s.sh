#!/bin/bash
set -x

source /root/.bashrc


cd /root
gpg -d  --batch --yes --passphrase "${GKE_TGZ_PASS}" gcp_cnf.tgz.gpg | tar xzvf -

gcloud container clusters list
gcloud container clusters get-credentials autopilot-cluster-1
kubectl get ns

NAMESPACE=go03
ls /
ls /manifests

if [ "$1" == "deploy" ] ; then
	cd /manifests
	kubectl apply -f *.yaml
	ls
	LIST=$(ls *.yaml | sort -n)
	for i in $LIST ; do
	   echo apply $i
	   kubectl apply -f $i
	done

        kubectl -n $NAMESPACE get all
fi

if [ "$1" == "delete" ] ; then
	cd /manifests
	ls
	LIST=$(ls *.yaml | sort -nr)
	for i in $LIST ; do
	   echo deleting $i
	   kubectl delete -f $i
	done

        kubectl -n $NAMESPACE get all
fi

if [ "$1" == "getAll" ] ; then
        kubectl -n $NAMESPACE get all
fi


