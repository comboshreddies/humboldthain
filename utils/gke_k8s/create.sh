#!/bin/bash
cd /root
gpg -d  --batch --yes --passphrase "${GKE_TGZ_PASS}" gcp_cnf.tgz.gpg | tar xzvf -

gcloud container clusters list
gcloud container clusters get-credentials autopilot-cluster-1
kubectl get ns

gcloud container --project "sonic-mile-358115" clusters create-auto "autopilot-cluster-1" --region "europe-west2" --release-channel "regular" --network "projects/sonic-mile-358115/global/networks/default" --subnetwork "projects/sonic-mile-358115/regions/europe-west2/subnetworks/default" --cluster-ipv4-cidr "/17" --services-ipv4-cidr "/22"

