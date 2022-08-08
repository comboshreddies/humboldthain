#!/bin/bash
source /root/.bashrc
cd /root
gpg -d  --batch --yes --passphrase "${GKE_TGZ_PASS}" gcp_cnf.tgz.gpg | tar xzvf -

gcloud container clusters list
gcloud container clusters get-credentials autopilot-cluster-1
kubectl get ns

if [ "$1" == "deploy" ] ; then
	cd /manifests
	kubectl apply -f *.yaml
fi

if [ "$1" == "delete" ] ; then
	cd /manifests
	kubectl delete -f *.yaml
fi

if [ "$1" == "getAll" ] ; then
	cd /manifests
	kubectl -n go03 get all
fi


