#!/bin/bash
cd /root
gpg -d  --batch --yes --passphrase "${GKE_TGZ_PASS}" gcp_cnf.tgz.gpg | tar xzvf -

gcloud container clusters list
gcloud container clusters get-credentials autopilot-cluster-1
kubectl get ns

echo Y | gcloud container --project "sonic-mile-358115" clusters delete  "autopilot-cluster-1" --region "europe-west2"

