# 🌍 Cost-Optimized Kubernetes Cluster on GCP with K3s

## Overview
This project provides a minimal and cost-effective Kubernetes cluster setup using **Google Cloud Platform (GCP)** and **K3s**. It provisions a lightweight cluster with a master and worker node, optimized for low-cost deployments.

## Features
- Minimal GCP resource usage for cost savings
- One master node and one preemptible worker node
- Lightweight Kubernetes distribution using **K3s**
- Ubuntu 22.04 LTS as the base image

## Prerequisites
Ensure you have the following installed and configured:
- [Google Cloud CLI](https://cloud.google.com/sdk/docs/install)
- A valid Google Cloud project

## Deployment Steps

### 1. Set Environment Variables
First, set the region and custom user variables:
```bash
export REGION=europe-west3
export MASTER_USER=k3s-master #clusteradmin
export WORKER_USER=k3s-worker
```

### 2. Create a Static IP for the Master Node
```bash
gcloud compute addresses create k3s-master-ip --region=$REGION
```

### 3. Create the Master Node
```bash
gcloud compute instances create k3s-master01 \
  --machine-type=e2-micro \
  --image-family=ubuntu-2204-lts \
  --image-project=ubuntu-os-cloud \
  --tags=k3s,master \
  --address=k3s-master-ip \
  --region=$REGION
```

### 4. Create a Preemptible Worker Node
```bash
gcloud compute instances create k3s-worker01 \
  --machine-type=e2-small \
  --image-family=ubuntu-2204-lts \
  --image-project=ubuntu-os-cloud \
  --tags=k3s,worker \
  --region=$REGION \
  --preemptible
```

## Cost Analysis
### Preemptible VMs
- **Definition:** Short-lived VMs that are much cheaper but can be terminated by GCP at any time.
- **Cost:** Up to 80% cheaper than regular instances.
- **Pros:**
  - Extremely cost-effective for short-lived or fault-tolerant workloads.
  - Ideal for batch processing and scalable applications.
- **Cons:**
  - Can be terminated anytime or after 24 hours of uptime.
  - Not suitable for critical services requiring high availability.

### e2-micro Instances
- **Definition:** Low-cost VM suitable for lightweight workloads.
- **Cost:** Free within GCP Free Tier, otherwise approx. €0.007/hour (~€5/month).
- **Pros:**
  - Free usage under specific limits.
  - Suitable for low-resource tasks or small applications.
- **Cons:**
  - Limited CPU and memory capacity.
  - Performance can fluctuate due to shared CPU resources.

## Challenges & Recommendations
- **Preemptible VM Challenges:**
  - Risk of unexpected shutdowns and data loss.
  - Limited to 24 hours of uptime.
  - Availability may be restricted during peak demand.

- **Recommendations:**
  - Implement backup mechanisms to prevent data loss.
  - Use Managed Instance Groups (MIGs) for automatic instance restarts.
  - Only deploy fault-tolerant workloads on Preemptible VMs.

## Verification
SSH into your instances using the specified custom usernames:
```bash
gcloud compute ssh $MASTER_USER@k3s-master01 --region=$REGION
gcloud compute ssh $WORKER_USER@k3s-worker01 --region=$REGION
```

## Future Improvements
- Add persistent storage solutions.
- Set up firewall rules for better security.
- Implement auto-scaling and load balancing.

## License
This project is licensed under the MIT License.

