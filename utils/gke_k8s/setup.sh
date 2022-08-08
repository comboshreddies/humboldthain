#!/bin/bash
source /root/.bashrc
cd /root
gpg -d  --batch --yes --passphrase "${GKE_TGZ_PASS}" gcp_cnf.tgz.gpg | tar xzvf -

gcloud container clusters list
gcloud container clusters get-credentials autopilot-cluster-1
kubectl get ns


