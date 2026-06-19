DevOps CI/CD Portfolio Project

A hands-on DevOps project built from scratch, covering containerization, infrastructure as code, cloud deployment, and CI/CD automation.

Repository: github.com/eaibrahim32/cicd-docker-kubernetes-terraform-aws-ec2


Tech Stack

Implemented:


App: Python (Flask) + MySQL
Containerization: Docker, docker-compose
Infrastructure as Code: Terraform (AWS EC2 provisioning)
Cloud: AWS (EC2, Security Groups) — region: ap-southeast-1 (Singapore)
CI/CD: Jenkins (Multibranch Pipeline, GitHub integration)
Automation: Bash scripts (backup, restart)
Dev Environment: GitHub Codespaces (zero local disk usage)


Planned (see Future Scope below):


Monitoring: Prometheus, Grafana, AWS CloudWatch
Configuration Management: Ansible
Logging: ELK Stack (Elasticsearch, Logstash, Kibana)
Container Orchestration: Kubernetes (Minikube)
Networking: HTTPS/TLS, reverse proxy, custom VPC, DNS



Progress So Far ✅

1. App + Docker (Done)


Built a simple Flask app (app/app.py) that connects to MySQL and shows a visit counter
Containerized with Dockerfile + docker-compose.yml (web + db services)
Tested and confirmed working locally in Codespaces (http://localhost:5000)


2. Bash Automation Scripts (Done)


scripts/backup_db.sh — dumps MySQL database with timestamp, tested successfully
scripts/restart_containers.sh — restarts docker-compose services
Both made executable with chmod +x


3. AWS Account + IAM Setup (Done)


Created AWS account (free tier)
Created IAM user devops-user with AdministratorAccess (for learning/portfolio purposes — not production practice)
Configured AWS CLI in Codespaces via aws configure
Region used: ap-southeast-1 (Singapore — closest to Bangladesh)


4. Terraform (Done)


Wrote terraform/main.tf, variables.tf, outputs.tf
Provisioned:

Security Group (devops-app-sg) — opens ports 22 (SSH), 5000 (app), 8080 (Jenkins)
EC2 instance (t3.micro, Amazon Linux 2, AMI: ami-0df749f12c31d3cd6)



Resolved issues along the way: wrong AMI region, free-tier instance type (t2.micro → t3.micro), key pair not existing in AWS (imported via aws ec2 import-key-pair)
Successfully ran terraform apply → got live public IP: 13.214.132.20
Verified instance running in AWS Console (3/3 status checks passed)


5. SSH + App Deployed to EC2 (Done)


Generated RSA key pair (devops-key.pem), secured with chmod 400
SSH'd into EC2: ssh -i ~/.ssh/devops-key.pem ec2-user@13.214.132.20
Installed Docker + Docker Compose v2.27.0 on EC2 (had to fix an old docker-compose version issue — compose build requires buildx 0.17.0 or later)
Copied project files to EC2 via scp
Ran docker-compose up -d --build successfully
App confirmed live at: http://13.214.132.20:5000 → "Hello from Docker + Jenkins + Terraform!"


6. GitHub Push (Done)


Pushed all code to GitHub
Hit and resolved a large-file push error (accidentally committed aws/ CLI installer and Terraform provider binaries — removed via git rm --cached, added to .gitignore)
Security fix: accidentally committed devops-key.pem (private SSH key) to the repo — removed it from git tracking and added to .gitignore


7. Jenkins CI/CD (Done ✅ — Just Completed)


Ran Jenkins in Docker (systemd install failed on Amazon Linux 2 due to a compatibility issue with StartLimitBurst/StartLimitIntervalSec, switched to Docker-based Jenkins instead)
Note: Jenkins ended up running inside GitHub Codespaces (not EC2) due to EC2 RAM constraints (t3.micro only has 1GB RAM — not enough for MySQL + Flask + Jenkins simultaneously)
Accessed Jenkins via Codespaces port forwarding: https://friendly-memory-jv9rg664v5xf59gg-8080.app.github.dev/
Created GitHub Personal Access Token (scopes: repo, workflow, admin:repo_hook) — note: original token was rotated/should be rotated since it was shared in screenshots
Added GitHub credentials to Jenkins
Created a Multibranch Pipeline job (devops-cicd-pipeline) connected to the GitHub repo
Created Jenkinsfile with 4 stages: Checkout → Build → Test → Deploy
Jenkins successfully scanned the repo, found the Jenkinsfile, and ran Build #1 — SUCCESS ✅



Current Live Resources

ResourceValueEC2 Public IP13.214.132.20App URLhttp://13.214.132.20:5000Jenkins URL (Codespaces)https://friendly-memory-jv9rg664v5xf59gg-8080.app.github.dev/ (changes if Codespace restarts)AWS Regionap-southeast-1 (Singapore)EC2 Instance Typet3.microGitHub Repogithub.com/eaibrahim32/cicd-docker-kubernetes-terraform-aws-ec2

⚠️ Important: EC2 instance and Jenkins (Codespaces-based) are temporary — not yet destroyed. Plan is to take all screenshots/recordings before running terraform destroy.


Known Issues / Lessons Learned


t3.micro (1GB RAM) is too small to run MySQL + Flask + Jenkins simultaneously — caused slowdowns and crashes
Amazon Linux 2 systemd has compatibility issues with newer Jenkins RPM packages — Docker-based Jenkins was the workaround
Large files (AWS CLI installer, Terraform provider binaries) must be .gitignore'd before first commit to avoid GitHub's file size limits
Never commit .pem private keys to git — always add to .gitignore immediately



Next Steps (Not Yet Done)


Kubernetes — Set up Minikube, convert docker-compose to K8s manifests (deployment, service), deploy app as pods
CloudWatch — Enable EC2 monitoring, create dashboard, set up CPU/alarm alerts
Staging vs Production environments — Terraform workspaces, separate docker-compose.staging.yml / docker-compose.prod.yml, GitHub Actions workflows per branch (develop → staging, main → production)
Permanent free hosting — Deploy app to Railway/Render for a permanent live URL (since AWS EC2 will eventually be destroyed)
README polish — Add architecture diagram, all screenshots, pin repo on GitHub profile
Security cleanup — Rotate GitHub token, double check no secrets remain in git history
terraform destroy — once all demos/screenshots/recordings are done, to avoid AWS charges



Future Scope (Planned — Not Started)

These are areas to explore next to round out the project as a fuller DevOps/SRE portfolio piece:

Monitoring & Observability


Prometheus — metrics collection from the app and EC2/Kubernetes (node-exporter, cAdvisor)
Grafana — dashboards built on top of Prometheus metrics (CPU, memory, request rate, container health)
Compare/contrast with CloudWatch (AWS-native vs open-source self-hosted monitoring)


Configuration Management


Ansible — replace manual SSH + bash setup steps (Docker install, app deployment) with idempotent Ansible playbooks
Use Ansible inventory to manage staging vs production hosts separately
Potential follow-up: Ansible Vault for secrets instead of plain .tfvars/.env files


Centralized Logging


ELK Stack (Elasticsearch, Logstash, Kibana) — or lighter alternative (Filebeat + Elasticsearch + Kibana) for centralized application and container logs
Ship logs from Docker containers / Kubernetes pods instead of relying on docker logs per container


Networking Fundamentals


Deepen practical understanding of:

HTTP vs HTTPS — add TLS/SSL termination (e.g., via Nginx reverse proxy or AWS Load Balancer + ACM certificate) instead of running the app on plain HTTP
Reverse proxy / Load balancing — put Nginx or an AWS Application Load Balancer in front of the app instead of exposing the EC2 port directly
DNS — point a real domain name at the app instead of using the raw EC2 IP
VPC networking — move from default VPC to a custom VPC with public/private subnet separation (app in public subnet, database in private subnet)
Firewalls/Security Groups — tighten security group rules (currently 0.0.0.0/0 on SSH — should restrict to specific IP)





Screenshots Captured So Far (9 images — to re-upload in next session)


App running locally in Codespaces (Hello from Docker + Jenkins + Terraform!)
docker-compose ps showing both containers running
terraform apply output showing instance_public_ip = "13.214.132.20"
AWS Console — EC2 instance running (3/3 status checks passed)
SSH session into EC2 ([ec2-user@ip-172-31-14-143 ~]$)
App live on AWS EC2 in browser (http://13.214.132.20:5000)
Backup script working (Backup saved to ./backups/appdb_...sql)
Jenkins "Welcome to Jenkins!" dashboard
Jenkins Build #1 successful (green checkmark, "Last successful build (#1)")


