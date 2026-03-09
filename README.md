# 🚀 EKS Terraform Infrastructure

![Terraform](https://img.shields.io/badge/IaC-Terraform-blue)
![AWS](https://img.shields.io/badge/Cloud-AWS-orange)
![Kubernetes](https://img.shields.io/badge/Container-Kubernetes-blue)
![DevOps](https://img.shields.io/badge/Practice-DevOps-green)
![License](https://img.shields.io/badge/License-MIT-yellow)

Infrastructure as Code (IaC) project for provisioning a **production-ready Amazon EKS cluster** using **Terraform**.

This repository demonstrates **DevOps best practices** for managing Kubernetes infrastructure on AWS using a **modular Terraform architecture**.

The goal of this project is to provide a **reusable, scalable, and maintainable infrastructure setup** for deploying containerized workloads in Kubernetes.

---

# 📌 Architecture Overview

The following diagram shows how Terraform provisions infrastructure resources to deploy a Kubernetes cluster on AWS.

```
Developer
   │
   │ Terraform CLI
   ▼
Terraform Configuration
   │
   │ API Calls
   ▼
AWS Infrastructure
   │
   ├── VPC
   │   ├── Public Subnets
   │   └── Private Subnets
   │
   ├── IAM Roles & Policies
   │
   └── Amazon EKS Cluster
        │
        ├── Worker Node Group
        │   └── EC2 Instances
        │
        └── Kubernetes Pods / Applications
```

---

# 🧱 Project Structure

```
eks-terraform
│
├── main.tf
│
├── modules
│   └── eks
│       ├── main.tf
│       ├── variables.tf
│       └── output.tf
│
└── README.md
```

### Structure Explanation

| File                       | Description                  |
| -------------------------- | ---------------------------- |
| `main.tf`                  | Root Terraform configuration |
| `modules/eks/main.tf`      | EKS infrastructure resources |
| `modules/eks/variables.tf` | Input variables              |
| `modules/eks/output.tf`    | Output values                |
| `README.md`                | Project documentation        |

---

# ⚙️ Technologies Used

| Tool       | Purpose                      |
| ---------- | ---------------------------- |
| Terraform  | Infrastructure as Code       |
| AWS EKS    | Managed Kubernetes Service   |
| AWS IAM    | Identity & Access Management |
| AWS VPC    | Networking layer             |
| Kubernetes | Container orchestration      |

---

# 🧰 Prerequisites

Ensure the following tools are installed before deploying the infrastructure.

| Tool      | Check Command              |
| --------- | -------------------------- |
| Terraform | `terraform -v`             |
| AWS CLI   | `aws --version`            |
| kubectl   | `kubectl version --client` |

You also need:

* AWS Account
* IAM permissions to create EKS resources

---

# ⚡ Deployment Guide

## 1️⃣ Clone Repository

```
git clone https://github.com/rushidholecom/eks-terraform.git
cd eks-terraform
```

---

## 2️⃣ Configure AWS Credentials

```
aws configure
```

Provide:

```
AWS Access Key
AWS Secret Access Key
Region
Output Format
```

---

## 3️⃣ Initialize Terraform

```
terraform init
```

This downloads required providers and modules.

---

## 4️⃣ Validate Configuration

```
terraform validate
```

---

## 5️⃣ Preview Infrastructure

```
terraform plan
```

Terraform will display the resources it plans to create.

---

## 6️⃣ Deploy Infrastructure

```
terraform apply
```

Confirm when prompted:

```
yes
```

Terraform will provision:

• VPC
• IAM Roles
• Amazon EKS Cluster
• Worker Node Groups

---

# ☸️ Configure kubectl

Once the cluster is created, update kubeconfig.

```
aws eks --region <region> update-kubeconfig --name <cluster-name>
```

Verify nodes:

```
kubectl get nodes
```

Expected output:

```
NAME               STATUS   ROLES    AGE
ip-10-0-1-10       Ready    <none>   2m
```

---

# 🧩 Terraform Module Example

This project uses a **modular architecture**.

Example usage:

```
module "eks" {
  source = "./modules/eks"

  cluster_name = "dev-eks-cluster"
  region       = "ap-south-1"
}
```

### Benefits of Modular Design

* Reusable Infrastructure
* Clean Terraform Code
* Easier Maintenance
* Scalable Architecture

---

# 🔐 DevOps Best Practices Implemented

✔ Infrastructure as Code
✔ Modular Terraform Design
✔ Version Controlled Infrastructure
✔ Cloud Native Kubernetes Deployment
✔ Reproducible Infrastructure Environments

---

# 📈 Future Improvements

Planned improvements for this repository:

* Terraform remote backend (S3 + DynamoDB)
* CI/CD pipeline using GitHub Actions
* Helm deployment for Kubernetes apps
* Monitoring with Prometheus & Grafana
* Automated security scanning

---

# 👨‍💻 Author

**Rushid Dhole**

DevOps Engineer
AWS | Kubernetes | Terraform | Docker | CI/CD

GitHub
https://github.com/rushidholecom

---

# 📜 License

This project is licensed under the **MIT License**.
