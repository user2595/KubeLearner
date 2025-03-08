#!/bin/bash

set -e
set -o pipefail

#run env.sh
source gcloude/scripte/.env


run_remote_command_master() {
  gcloud compute ssh $MASTER_USER@$MASTER_NAME --zone=$MASTER_ZONE -- "$1"

}

# Add preemptible flag to worker nodes if required
if [ "$PREEMPTIBLE" = true ]; then
  WORKER_FLAGS+=" --preemptible"
fi

# Create a static IP for the master
echo "Creating a static IP for the master"
if ! gcloud compute addresses describe $MASTER_STATIC_IP_NAME --region=$REGION &> /dev/null; then
  gcloud compute addresses create $MASTER_STATIC_IP_NAME --region=$REGION
  # Wait for the static IP to be created
  while true; do
  echo "Waiting for the static IP to be created"
    if gcloud compute addresses describe $MASTER_STATIC_IP_NAME --region=$REGION --format='value(address)' | grep -q '[0-9]'; then
      break
    fi
    sleep 5
  done
fi
# Create the master instance
echo "Creating the master instance"

for i in $(seq $MASTER_COUNT); do
  if ! gcloud compute instances describe $MASTER_NAME --zone=$MASTER_ZONE &> /dev/null; then
    gcloud compute instances create $MASTER_NAME $MASTER_FLAGS
  fi
done
# Create worker instances
echo "Creating the worker instances"
for i in $(seq $WORKER_COUNT); do
  if ! gcloud compute instances describe "${WORKER_NAME}${i}" --zone=$WORKER_ZONE &> /dev/null; then
    gcloud compute instances create "${WORKER_NAME}${i}" $WORKER_FLAGS
  fi
done



echo "Waiting for the instances to be created"

while true; do
  echo "Waiting for the instances to be created"
  MASTER_STATUS=$(gcloud compute instances describe $MASTER_NAME${MASTER_COUNT} --zone=$MASTER_ZONE --format='value(status)')
  WORKER_STATUS=$(gcloud compute instances describe "${WORKER_NAME}${WORKER_COUNT}" --zone=$WORKER_ZONE --format='value(status)')
  echo "Master status: $MASTER_STATUS | Worker status: $WORKER_STATUS"
  if [ "$MASTER_STATUS" = "RUNNING" ] && [ "$WORKER_STATUS" = "RUNNING" ]; then
    break
  fi
  sleep 5
done

# Test SSH connection
echo "Test SSH connection"
for i in $(seq 1 $MASTER_COUNT); do
  echo "SSH into master ${i}"
  gcloud compute ssh $MASTER_USER@"$MASTER_NAME${i}" --zone=$MASTER_ZONE -- echo "SSH into master successful && exit 0"
done




for i in $(seq 1 $WORKER_COUNT); do
  echo "SSH into worker ${i}"
  gcloud compute ssh $WORKER_USER@"${WORKER_NAME}${i}" --zone=$WORKER_ZONE -- echo "SSH into worker ${i} successful && exit 0"
done