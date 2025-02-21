gcloud compute addresses create k3s-master-ip --region=$europe-west3

gcloud compute instances create k3s-master01 \
  --machine-type=e2-micro\
  --image-family=ubuntu-2204-lts \
  --image-project=ubuntu-os-cloud \
  --tags=k3s,master \
  --address=k3s-master-ip \
  --region=europe-west3

gcloud compute instances create k3s-worker01 \
  --machine-type=e2-small \
  --image-family=ubuntu-2204-lts \
  --image-project=ubuntu-os-cloud \
  --tags=k3s,worker \
  --region=europe-west3 \
  --preemptible

gcloud compute instances create k3s-worker02 \
  --machine-type=e2-small \
  --image-family=ubuntu-2204-lts \
  --image-project=ubuntu-os-cloud \
  --tags=k3s,worker \
  --region=europe-west3 \
  --preemptible