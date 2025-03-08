# 🚀 Kubernetes Cluster Deployment with GCloud, Terraform, and Ansible
https://nimblehq.co/blog/provision-k3s-on-google-cloud-with-terraform-and-k3sup
## Overview
This repository serves as a comprehensive learning project for deploying Kubernetes clusters using **K3s**, **Google Cloud Platform (GCP)**, **Terraform**, and **Ansible**. The goal is to build and manage a fully functional Kubernetes cluster with various features incrementally integrated.

## Features
- Lightweight Kubernetes deployment using **K3s**
- Infrastructure provisioning with **Terraform**
- Configuration management and automation with **Ansible**
- Seamless integration with **Google Cloud Platform (GCP)**
- Support for deploying multiple environments (dev, staging, production)
- Scalable and modular infrastructure setup

## Prerequisites
Before starting, ensure you have the following installed:

- [Google Cloud CLI](https://cloud.google.com/sdk/docs/install)
- [Terraform](https://www.terraform.io/downloads)
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
- [Kubectl](https://kubernetes.io/docs/tasks/tools/)

## Project Structure
```
├── terraform/          # Terraform scripts for infrastructure provisioning
│   ├── main.tf         # Main Terraform configuration
│   ├── variables.tf    # Input variables
│   ├── outputs.tf      # Output values
│   └── providers.tf    # Provider configurations (GCP)
│
├── ansible/            # Ansible playbooks for configuration management
│   ├── playbook.yml    # Main playbook
│   └── roles/          # Custom roles
│
├── k3s/                # K3s cluster setup scripts
│   ├── install.sh      # Installation script for K3s
│   └── config/         # Configuration files
│
├── scripts/            # Helper scripts
│   ├── deploy.sh       # Deployment automation
│   └── cleanup.sh      # Cleanup resources
│
├── .gitignore          # Git ignore file for untracked files
└── README.md           # Project documentation
```

## Usage
### 1. Set up GCP credentials
Ensure your Google Cloud credentials are set up correctly:
```bash
 gcloud auth login
 gcloud config set project <your-gcp-project-id>
```

### 2. Provision Infrastructure
Use Terraform to set up the required infrastructure:
```bash
cd terraform
terraform init
terraform apply
```

### 3. Configure Kubernetes Cluster
Run the Ansible playbook to configure the K3s cluster:
```bash
cd ansible
ansible-playbook playbook.yml
```

### 4. Verify Cluster Status
Check if your cluster is running:
```bash
kubectl get nodes
```

## Future Improvements
- Add monitoring and logging (Prometheus, Grafana)
- Implement CI/CD pipelines
- Enable autoscaling and resource limits
- Set up role-based access control (RBAC)

## Contributing
Contributions are welcome! Please submit a pull request or open an issue if you'd like to help improve this project.

## License
This project is licensed under the MIT License.



