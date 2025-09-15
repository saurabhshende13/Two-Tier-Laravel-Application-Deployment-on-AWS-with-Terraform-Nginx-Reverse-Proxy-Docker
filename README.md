# 🌐 Two-Tier Laravel Application Deployment on AWS (Terraform + Nginx + Docker)

## 📖 Overview
This project demonstrates deploying a **two-tier Laravel application** on AWS using **Terraform**, **Nginx reverse proxy**, and **Docker Compose**.  

The setup ensures **security** (private app servers), **scalability** (Auto Scaling), and **SSL termination** (via ACM).  

---

## 🏗️ Architecture

- **VPC (10.0.0.0/16)**
- **Subnets**
  - Public Subnet → Nginx reverse proxy (Tier 1)
  - Private Subnet → Laravel App servers (Tier 2) behind internal ALB
- **Load Balancers**
  - External ALB (internet-facing) → Forwards requests to Nginx
  - Internal ALB (private) → Forwards Nginx traffic to Laravel App Auto Scaling Group
- **Route53 + ACM**
  - Custom domain mapped to External ALB
  - SSL certificate for HTTPS traffic

---

## ⚙️ Prerequisites

- AWS Account with admin access
- Terraform ≥ 1.0
- AWS CLI configured (`aws configure`)
- Domain name in Route53
- ACM Certificate for the domain (validated)

---

## 📂 Project Structure

```

.
├── terraform/          # Terraform IaC for VPC, Subnets, ALBs, EC2, ASG
├── nginx/              # Nginx reverse proxy configuration
├── docker/             # Docker Compose setup for Laravel app
├── diagram/            # Architecture diagram
└── README.md           # Documentation

````

---

## 🚀 Deployment Steps

### 1. Provision Infrastructure
```bash
cd terraform
terraform init
terraform apply -auto-approve
````

Terraform creates:

* VPC, public + private subnets
* Security groups
* External + internal ALBs
* Nginx EC2 instance (public subnet)
* Laravel app Auto Scaling Group (private subnet)

---

### 2. Validate Nginx Setup

SSH into Nginx instance:

```bash
ssh -i <key.pem> ubuntu@<nginx-public-ip>
```

Check Nginx status:

```bash
sudo systemctl status nginx
```

Nginx is configured to **reverse proxy traffic** to the **internal ALB**.

---

### 3. Verify External Load Balancer

Get the DNS name of the external ALB:

```bash
terraform output external_alb_dns
```

Open in browser:

```
http://<external-alb-dns>
```

You should see the Laravel application served via Nginx → internal ALB → app servers.

---

### 4. Configure Route53 + SSL

1. In Route53, create an **Alias Record (A)** pointing your domain → external ALB DNS.
2. Attach the validated **ACM certificate** to the external ALB HTTPS listener.
3. Test your app over HTTPS:

```
https://your-domain.com
```

---

## ✅ Verification Checklist

* [ ] Infrastructure created successfully with Terraform
* [ ] Nginx accessible in public subnet
* [ ] Internal ALB distributing traffic to Laravel app servers
* [ ] External ALB accessible from the internet
* [ ] Domain resolves correctly with HTTPS (ACM certificate)

---

## 🔒 Security Highlights

* Only **Nginx EC2** is in a public subnet
* Laravel app servers are in **private subnet** (not directly internet-facing)
* Security groups enforce least privilege:

  * External ALB: ports 80/443 open to world
  * Nginx: accepts traffic only from external ALB
  * Internal ALB: accepts traffic only from Nginx
* SSL termination handled at external ALB with ACM

---

## 📜 License

This project is licensed under the MIT License.

```
```
