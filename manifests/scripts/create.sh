#!/bin/bash
source /root/setup.sh

gcloud container --project "sonic-mile-358115" clusters create-auto "autopilot-cluster-1" --region "europe-west2" --release-channel "regular" --network "projects/sonic-mile-358115/global/networks/default" --subnetwork "projects/sonic-mile-358115/regions/europe-west2/subnetworks/default" --cluster-ipv4-cidr "/17" --services-ipv4-cidr "/22"

