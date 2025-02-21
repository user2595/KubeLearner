#!/bin/bash

set -e
set -o pipefail

source scripte/.env

# clean up the master instance and worker instances and the static IP
echo "Cleaning up the master instance "
if gcloud compute instances describe $MASTER_NAME --zone=$MASTER_ZONE &> /dev/null; then
    gcloud compute instances delete $MASTER_NAME --zone=$MASTER_ZONE --quiet
fi
echo "Cleaning up the worker instances "
for i in $(seq 1 $WORKER_COUNT); do
    if gcloud compute instances describe $WORKER_NAME-$i --zone=$WORKER_ZONE &> /dev/null; then
        gcloud compute instances delete $WORKER_NAME-$i --zone=$WORKER_ZONE --quiet
    fi
done
echo "Cleaning up the static IP"
if gcloud compute addresses describe $MASTER_STATIC_IP_NAME --region=$REGION &> /dev/null; then
    gcloud compute addresses delete $MASTER_STATIC_IP_NAME --region=$REGION --quiet
fi
