#!/bin/bash
source /root/setup.sh

echo Y | gcloud container --project "sonic-mile-358115" clusters delete  "autopilot-cluster-1" --region "europe-west2"

