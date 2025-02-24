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
# Set up region and image settings
export REGION=<REGION>
export IMAGE_FAMILY=<IMAGE_FAMILY>
export IMAGE_PROJECT=<IMAGE_PROJECT>
# Master node configuration
export MASTER_STATIC_IP_NAME=<STATIC_IP_NAME>
export MASTER_USER=<MASTER_USERNAME>
export MASTER_NAME=<MASTER_NAME>
export MASTER_TYPE=<MASTER_TYPE>
export MASTER_TAG=<MASTER_TAG1,MATER_TAG2>
# Worker node configuration
export WORKER_USER=k3s-worker
export WORKER_NAME=k3s-worker
export WORKER_TYPE=e2-small
export WORKER_TAG=k3s,worker
export WORKER_COUNT=1
export PREEMPTIBLE=true
# Master flags (All-in-One)
export MASTER_FLAGS="\
  --machine-type=$MASTER_TYPE \
  --image-family=$IMAGE_FAMILY \
  --image-project=$IMAGE_PROJECT \
  --tags=$MASTER_TAG \
  --address=$MASTER_STATIC_IP_NAME \
  --region=$REGION"
# Worker flags (All-in-One)
export WORKER_FLAGS="\
  --machine-type=$WORKER_TYPE \
  --image-family=$IMAGE_FAMILY \
  --image-project=$IMAGE_PROJECT \
  --tags=$WORKER_TAG \
  --region=$REGION"
# Add preemptible flag to worker nodes if required
if [ "$PREEMPTIBLE" = true ]; then
  WORKER_FLAGS+=" --preemptible"
fi
```
### 2. Create a Static IP for the Master Node
```bash
gcloud compute addresses create $STATIC_IP_NAME --region=$REGION
```
### 3. Create the Master Node
```bash
* creat a master node name k3s-master01
gcloud compute instances create $MASTER_NAME $MASTER_FLAGS
```
### 4. Create a Preemptible Worker Node
```bash
for i in $(seq 1 $WORKER_COUNT); do
  gcloud compute instances create "${WORKER_NAME}${i}" $WORKER_FLAGS
done
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
echo "Test SSH connection"
gcloud compute ssh $MASTER_USER@$MASTER_NAME --region=$REGION
for i in $(seq 1 $WORKER_COUNT); do
  gcloud compute ssh $WORKER_USER@"${WORKER_NAME}${i}" --region=$REGION
done
```
## Future Improvements
- Add persistent storage solutions.
- Set up firewall rules for better security.
- Implement auto-scaling and load balancing.
- migrate to terraform
- Implement CI/CD pipelines for automated deployments.
- Enable monitoring and logging for better observability.
- Set up role-based access control (RBAC) for security.
- Implement network policies for better isolation.
- Add Helm charts for application deployment.
- healte check for the master node and application
- add a load balancer for the master node
- set up  Multi-Zone-Managed Instance Group (MIG) for the worker node
- set up a firewall rule for the worker node



## License
This project is licensed under the MIT License.

