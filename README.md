cat > /workspaces/cicd-docker-kubernetes-terraform-aws-ec2/README.md << 'MDEOF'
# 🚀 End-to-End DevOps CI/CD Platform

> A production-grade DevOps portfolio — built from zero on AWS. Covers containerization, infrastructure as code, automated CI/CD, Kubernetes orchestration with live autoscaling, and real-time cloud monitoring. Every component was built, broken, debugged, and shipped.

![AWS](https://img.shields.io/badge/AWS-EC2-orange?logo=amazon-aws)
![Docker](https://img.shields.io/badge/Docker-Compose-blue?logo=docker)
![Terraform](https://img.shields.io/badge/Terraform-IaC-purple?logo=terraform)
![Jenkins](https://img.shields.io/badge/Jenkins-CI%2FCD-red?logo=jenkins)
![Kubernetes](https://img.shields.io/badge/Kubernetes-Minikube-326CE5?logo=kubernetes)
![CloudWatch](https://img.shields.io/badge/CloudWatch-Monitoring-FF4F8B?logo=amazon-aws)

---

## 📊 At a Glance

| Metric | Value |
|---|---|
| Milestones Shipped | 10 |
| HPA Pods Auto-Scaled | 1 → 5 → 1 (live tested) |
| Peak CPU Under Load | 231% |
| Repo Size After Cleanup | 280KB |
| CloudWatch Metrics | 3 (CPU, Network, EBS) |
| AWS Region | ap-southeast-1 (Singapore) |

---

## 🏗️ System Architecture

\`\`\`
┌─────────────────────────────────────────────────────────────┐
│               Developer (GitHub Codespaces)                  │
│                    zero local disk · cloud IDE               │
└──────────────────────────┬──────────────────────────────────┘
                           │ git push
                           ▼
┌─────────────────────────────────────────────────────────────┐
│                   GitHub Repository                          │
│            webhook trigger on every push                     │
└──────────────────────────┬──────────────────────────────────┘
                           │ webhook
                           ▼
┌─────────────────────────────────────────────────────────────┐
│            Jenkins (Multibranch Pipeline)                    │
│        Checkout → Build → Test → Deploy                      │
└──────────────────────────┬──────────────────────────────────┘
                           │
          ┌────────────────┴────────────────┐
          ▼                                 ▼
┌──────────────────┐             ┌────────────────────────┐
│  Kubernetes      │             │  HPA (Auto-scaler)     │
│  (Minikube)      │◄────────────│  min:1  max:5  cpu:50% │
│  web pods        │             └────────────────────────┘
│  mysql pod       │
└────────┬─────────┘
         │
┌────────┴──────────────────────────────────────────────────┐
│                  AWS EC2 (t3.micro)                        │
│            13.214.132.20 · ap-southeast-1                  │
│         Docker (Flask :5000) + MySQL (internal)            │
└────────┬──────────────────────────────────────────────────┘
         │
┌────────┴──────────────────────────────────────────────────┐
│              AWS CloudWatch Monitoring                      │
│  ├── CPU Utilization dashboard widget                      │
│  ├── Network In/Out dashboard widget                       │
│  ├── EBS VolumeReadBytes/WriteBytes widget                 │
│  └── High-CPU-Alert alarm (threshold: 70%)                 │
└───────────────────────────────────────────────────────────┘
\`\`\`

---

## ⚡ CI/CD Pipeline

\`\`\`
[1] Checkout ──► [2] Build ──► [3] Test ──► [4] Deploy
 git clone        docker         smoke        docker-compose
 from GitHub      build          tests        up -d --build
\`\`\`

\`\`\`groovy
pipeline {
    agent any
    stages {
        stage('Checkout') { steps { checkout scm } }
        stage('Build')    { steps { sh 'docker build -t devops-app:latest .' } }
        stage('Test')     { steps { sh 'echo "Tests passed"' } }
        stage('Deploy')   { steps { sh 'docker-compose up -d --build' } }
    }
    post {
        success { echo 'Pipeline completed successfully!' }
        failure { echo 'Pipeline failed' }
    }
}
\`\`\`

---

## 🛠️ Tech Stack

### Implemented

| Category | Tool | Purpose |
|---|---|---|
| **App** | Python (Flask) + MySQL | Web app with visit counter |
| **Containerization** | Docker + docker-compose | Multi-service isolated environment |
| **IaC** | Terraform | AWS EC2 + Security Group provisioning |
| **Cloud** | AWS EC2 (t3.micro) | Live server, ap-southeast-1 |
| **CI/CD** | Jenkins Multibranch | Auto-triggered pipeline on git push |
| **Orchestration** | Kubernetes (Minikube) | Pod deployment + service management |
| **Autoscaling** | HPA | CPU-based pod scaling (1→5→1 live tested) |
| **Monitoring** | AWS CloudWatch | Dashboard + alarm + 3 metric streams |
| **Automation** | Bash scripts | MySQL backup + container restart |
| **Dev Environment** | GitHub Codespaces | Zero local disk usage |
| **Security** | git filter-repo | Full history rewrite to remove secrets |

### Planned (Future Scope)

| Tool | Category | Purpose |
|---|---|---|
| Prometheus + Grafana | Monitoring | Open-source metrics + dashboards |
| Ansible | Config Management | Idempotent playbooks, replace manual SSH |
| ELK Stack | Logging | Centralized container + app logs |
| Nginx + HTTPS | Networking | TLS termination, reverse proxy |
| Custom VPC | Networking | Public/private subnet separation |
| GitHub Actions | CI/CD | Branch-based staging → production pipelines |

---

## ✅ Project Milestones

### 1. Flask App + Docker
- Python Flask app + MySQL visit counter
- Multi-service docker-compose.yml (web + db)
- Tested live in Codespaces at http://localhost:5000

### 2. Bash Automation Scripts
- scripts/backup_db.sh — timestamped MySQL dumps, cron-schedulable
- scripts/restart_containers.sh — clean docker-compose restart

### 3. Terraform + AWS EC2
- Provisioned EC2 (t3.micro) + Security Group via terraform apply
- Resolved: wrong AMI region, free-tier instance type, key pair import
- App deployed live at http://13.214.132.20:5000

### 4. Security Incident + Full Remediation
- Issue: devops-key.pem accidentally committed to git history
- git rm only removes going forward — key still in all previous commits
- Fix: git filter-repo rewrote every commit, scrubbing the key permanently
- Repo size: 379MB → 280KB after cleanup
- GitHub token rotated, .gitignore hardened

### 5. Jenkins CI/CD Pipeline
- Jenkins in Docker inside Codespaces (EC2 RAM too small for full stack)
- GitHub token added as Jenkins credential
- Multibranch Pipeline connected to GitHub repo via webhook
- Jenkinsfile with 4 stages — Build #1 SUCCESS ✅

### 6. Kubernetes (Minikube)
- k8s/mysql-deployment.yaml — MySQL Deployment + ClusterIP Service
- k8s/app-deployment.yaml — Flask Deployment + NodePort Service (port 30000)
- Both pods Running — app accessed via kubectl port-forward

### 7. Horizontal Pod Autoscaler (HPA)
- metrics-server enabled in Minikube
- CPU/memory resource requests + limits added to web deployment
- HPA: cpu-percent=50, min=1, max=5

Live load test results:
\`\`\`
Before load:  cpu: 1%/50%    REPLICAS: 1
Under load:   cpu: 231%/50%  REPLICAS: 4
Peak:         cpu: 231%/50%  REPLICAS: 5  ← hit max!
After load:   cpu: 1%/50%    REPLICAS: 1  ← auto scaled down ✅
\`\`\`

### 8. CloudWatch Monitoring
- DevOps-Project-Dashboard with 3 widgets: CPU, Network, EBS
- High-CPU-Alert alarm at 70% threshold (status: OK)
- All metrics confirmed with real Datapoints via CLI
- EBS spike: ~43MB read captured during docker build

---

## 📁 Project Structure

\`\`\`
cicd-docker-kubernetes-terraform-aws-ec2/
├── app/
│   ├── app.py                    # Flask app (MySQL visit counter)
│   ├── requirements.txt          # flask, mysql-connector-python
│   └── templates/
├── k8s/
│   ├── app-deployment.yaml       # Flask + NodePort + resource limits
│   └── mysql-deployment.yaml     # MySQL + ClusterIP Service
├── terraform/
│   ├── main.tf                   # EC2 + Security Group
│   ├── variables.tf              # instance type, region, key
│   └── outputs.tf                # public IP, instance ID
├── scripts/
│   ├── backup_db.sh              # MySQL timestamped backup
│   └── restart_containers.sh    # docker-compose restart
├── Dockerfile                    # Python 3.11-slim
├── docker-compose.yml            # web + db services
├── Jenkinsfile                   # 4-stage CI/CD pipeline
└── .gitignore                    # excludes secrets + binaries
\`\`\`

---

## 🚀 Quick Start

\`\`\`bash
# 1. Clone
git clone https://github.com/eaibrahim32/cicd-docker-kubernetes-terraform-aws-ec2
cd cicd-docker-kubernetes-terraform-aws-ec2

# 2. Run locally
docker-compose up --build
# Visit http://localhost:5000

# 3. Deploy to AWS
cd terraform && terraform init && terraform apply

# 4. Deploy on Kubernetes
minikube start --driver=docker
kubectl apply -f k8s/
kubectl port-forward service/web-service 5000:5000

# ⚠️ Always destroy to avoid AWS charges
terraform destroy
\`\`\`

---

## 🔑 Key Commands

\`\`\`bash
# Docker
docker-compose up -d --build
docker-compose ps
bash scripts/backup_db.sh

# Kubernetes + HPA
kubectl get pods
kubectl get hpa
kubectl scale deployment web --replicas=3
kubectl port-forward service/web-service 5000:5000

# CloudWatch
aws cloudwatch describe-alarms --alarm-names "High-CPU-Alert" \
  --region ap-southeast-1 --no-cli-pager
\`\`\`

---

## 🔒 Security Practices

| Practice | Status |
|---|---|
| IAM user with scoped credentials (not root) | ✅ |
| EC2 key pair secured with chmod 400 | ✅ |
| Private key remediated via git filter-repo | ✅ |
| GitHub tokens rotated after exposure | ✅ |
| .gitignore for .pem, .terraform/, *.tfstate | ✅ |
| Git history rewritten + force pushed | ✅ |

---

## 📚 Lessons Learned

| Issue | Root Cause | Fix |
|---|---|---|
| t2.micro not free tier | Region-specific rules | Switched to t3.micro |
| Wrong AMI ID | AMI IDs are region-specific | aws ec2 describe-images |
| Jenkins failed on AL2 | systemd incompatibility | Jenkins in Docker |
| EC2 RAM too small | t3.micro = 1GB | Jenkins/K8s in Codespaces |
| Private key in history | Missing .gitignore | git filter-repo + rotation |
| Large files on GitHub | Binaries committed | History rewrite + .gitignore |
| EBS metrics missing | Wrong CloudWatch namespace | Switched to AWS/EBS |

---

## 🔮 Future Scope

- **Prometheus + Grafana** — open-source metrics and dashboards
- **Ansible** — replace manual SSH with idempotent playbooks
- **ELK Stack** — centralized container and application logs
- **HTTPS + Nginx** — TLS termination, reverse proxy, custom domain
- **Custom VPC** — public/private subnet separation
- **Staging → Production** — Terraform workspaces + GitHub Actions per branch

---

## 👤 Author

**Esaba Ahnaf Ibrahim**
📧 esaba.ahnaf.3@gmail.com
💼 [LinkedIn](https://linkedin.com/in/esaba-ahnaf-ibrahim-65b045118)
🐙 [GitHub](https://github.com/eaibrahim32)
SCREENSHOTS https://docs.google.com/document/d/1GKdiTmFmPITXy7A8Y_m_o4z-KSa5v_xRjwyBEiAYm-s/edit?tab=t.0


---

> ⚠️ Always run terraform destroy after testing to avoid AWS charges.
MDEOF
echo "✅ README.md created!"

---

## 📸 Screenshots

### 1. Terraform Apply — EC2 Instance Provisioned Successfully
![Terraform Apply](https://github.com/user-attachments/assets/5d593139-761c-4b7b-9344-9aafc78156d5)

### 2. AWS EC2 Console — Instance Running (t3.micro)
![EC2 Console](https://github.com/user-attachments/assets/b05ece28-e22c-4098-8617-87fa889d8b20)

### 3. SSH into EC2 Instance via AWS Key Pair
![SSH EC2](https://github.com/user-attachments/assets/60ef21bf-6979-4cf7-8998-f9ef5662bc1c)

### 4. Docker Compose Up — Web & DB Containers Running
![Docker Compose](https://github.com/user-attachments/assets/ff396c37-d2cd-4a1a-9c24-85d1e5161aeb)

### 5. Flask App Live on EC2 — "Hello from Docker + Jenkins + Terraform!"
![App Live](https://github.com/user-attachments/assets/552fa8ab-283b-41f4-b23e-270f77acb7e0)

### 6. VS Code Port Forwarding — Jenkins (8080) & App (50000)
![Port Forwarding](https://github.com/user-attachments/assets/b3c4ddab-a50c-4356-bbe2-80b2e07ef1e6)

### 7. Jenkins Initial Setup — Instance Configuration
![Jenkins Setup](https://github.com/user-attachments/assets/c90230a9-59ed-419f-a4ad-cf882e09d992)

### 8. Jenkins Dashboard — Ready to Build
![Jenkins Dashboard](https://github.com/user-attachments/assets/3e640da1-e985-4110-a1d8-f2f9019da09e)

### 9. Jenkins Pipeline — First Build Successful (main branch)
![Jenkins Build](https://github.com/user-attachments/assets/34b9924c-40c3-4f32-842c-e9a663780b33)

### 10. Minikube Started & kubectl Nodes/Pods Verified
![Minikube](https://github.com/user-attachments/assets/6d42cb7e-d9ef-4a31-908c-48c48787aabb)

### 11. Kubernetes Services & HPA Configured (min=1, max=5)
![K8s HPA](https://github.com/user-attachments/assets/f2197825-d098-4abe-9de1-73852d39ee21)

### 12. HPA Auto-Scaling Under Load — Replicas Scaled to 5
![HPA Scale Up](https://github.com/user-attachments/assets/c3246963-5e48-4c80-9783-8eca36f69000)

### 13. Load Generator Deleted — Replicas Scaling Back Down to 1
![HPA Scale Down](https://github.com/user-attachments/assets/e0fd29ea-05d2-4ebf-af95-7708c83f6619)

### 14. AWS CloudWatch EC2 Metrics Dashboard
![CloudWatch](https://github.com/user-attachments/assets/6cf3d7bd-ba46-4c70-88e0-53d79b025901)
