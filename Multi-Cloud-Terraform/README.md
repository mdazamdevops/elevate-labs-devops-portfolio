## Multi-Cloud Auto Deployment using Terraform (AWS + GCP Free Tier)
* Elevate Labs: Empowering the Future of DevOps
This project is a testament to the high-quality, hands-on learning experience provided by Elevate Labs. Their internship program is dedicated to empowering the next generation of DevOps professionals by offering practical, real-world challenges that build foundational skills and a deep understanding of modern software development practices.

## Project Overview
Objective: Provision resources in both AWS and GCP simultaneously and validate auto-deployment with a single command using Terraform infrastructure as code.

Tools: Terraform, AWS Free Tier, GCP Free Tier, NGINX, DNSMasq (local)
## Architecture
Multi-Cloud Infrastructure Diagram
Diagram

graph TB
    subgraph AWS Cloud (ap-south-1)
        A1[VPC: 10.0.0.0/16]
        A2[Internet Gateway]
        A3[Public Subnet: 10.0.1.0/24]
        A4[EC2 Instance: t2.micro]
        A5[Security Group: HTTP/HTTPS/SSH]
        A6[Elastic IP]
        
        A1 --> A2
        A1 --> A3
        A3 --> A4
        A4 --> A5
        A4 --> A6
    end

    subgraph GCP Cloud (us-central1)
        G1[Default Network]
        G2[Compute Instance: f1-micro]
        G3[External IP]
        G4[Firewall Rules]
        
        G1 --> G2
        G2 --> G3
        G1 --> G4
    end

    User[End User] --> Internet
    Internet --> A6
    Internet --> G3
    
    A4 --> App[QR Scanner Application]
    G2 --> App

## Project Structure
```
multi-cloud-qr-scanner/
├── providers.tf          # Cloud provider configurations
├── variables.tf          # Input variables
├── main.tf              # Main configuration
├── outputs.tf           # Output values
├── aws-resources.tf     # AWS infrastructure
├── gcp-resources.tf     # GCP infrastructure
├── scripts/
│   └── deploy-qr-scanner.sh  # Application deployment script
├── .gitignore          # Git ignore rules
├── README.md           # This file
└── infrastructure-diagram.png  # Architecture diagram
```
## Features
* Multi-Cloud Deployment: Simultaneous provisioning on AWS and GCP
* Free Tier Compliance: Uses only free-tier eligible resources
* Automated Deployment: Single command setup (terraform apply)
* Health Checks: Automatic validation of both cloud deployments

## Infrastructure as Code: Complete Terraform configuration

* QR Scanner Application: Ready-to-deploy web application
* Prerequisites
  Tools Required
  Terraform (>= 1.0)

* AWS CLI (configured with credentials)

* Google Cloud SDK (gcloud)
Git

## Accounts Required
AWS Account with Free Tier eligibility

Google Cloud Platform Account

## SSH Key Pair
* Installation & Setup
1. Clone the Repository
bash
git clone <repository-url>
cd multi-cloud-qr-scanner
2. Configure Cloud Credentials
AWS Configuration:

```
aws configure
# Enter AWS Access Key, Secret Key, Region: ap-south-1
GCP Configuration:

```
* gcloud auth application-default login
gcloud config set project YOUR_PROJECT_ID
## 3. Set Up Terraform Variables
```
# Create terraform.tfvars file
cat > terraform.tfvars << EOF
gcp_project_id = "your-gcp-project-id"
ssh_public_key = "ssh-rsa your-public-key-content"
EOF
4. Initialize Terraform
bash
terraform init
🚀 Deployment
Single Command Deployment
```
* terraform apply -auto-approve
Manual Approval Deployment
```
```
terraform plan    # Review changes
terraform apply   # Confirm deployment
✅ Validation Steps
After deployment, validate using:
## 1. Check Outputs
```
terraform output
# Should display both AWS and GCP instance IPs
```
## 2. Test Application Access
### Test AWS instance
curl http://$(terraform output -raw aws_instance_ip)
```
# Test GCP instance  
curl http://$(terraform output -raw gcp_instance_ip)
```
## 3. Health Check Automation
The deployment includes automatic health checks that verify:

Both instances are reachable via HTTP
NGINX is serving the QR scanner application
Cloud resources are properly configured

## 4. Cloud Console Verification
AWS Console Checks:
* EC2 Instance running (t2.micro)
Elastic IP assigned
Security group with proper rules
VPC and networking configured
GCP Console Checks:
Compute Engine instance running (f1-micro)
External IP assigned
Default network utilized
Firewall rules effective
---
## Cleanup
To destroy all resources and avoid charges:

```
terraform destroy -auto-approve
```
## Troubleshooting
Common Issues
GCP Permission Errors: Ensure service account has Compute Admin role

AWS Key Pair Exists: Delete existing key pair or use different name

Image Not Found: Use correct Ubuntu image family for GCP

Authentication Issues: Verify both AWS and GCP credentials

Debug Commands
```
# Verify AWS configuration
aws sts get-caller-identity

# Verify GCP configuration  
gcloud auth list
gcloud config get-value project

# Check Terraform state
terraform state list
```
## Learning Outcomes
* This project demonstrates:
Multi-Cloud Strategy: Deploying across AWS and GCP
Infrastructure as Code: Terraform best practices
Cloud Networking: VPC, subnets, security groups, firewalls
Automated Deployment: Single-command infrastructure provisioning
Cost Optimization: Free tier resource utilization
Monitoring & Validation: Health checks and deployment verification

## Contributing
* This project was developed as part of the Elevate Labs DevOps internship program. For improvements or suggestions, please follow standard Git workflow:
```
Fork the repository
Create a feature branch
Commit changes
Push to branch
Create Pull Request
```
## License
This project is part of the Elevate Labs internship program and is intended for educational purposes.

## Creator
Name: Mohd Azam Uddin

Role: DevOps Intern at Elevate Labs