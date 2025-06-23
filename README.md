
# Strapi Application Deployment - Task Breakdown

This guide walks you through three key stages: running Strapi locally, containerizing it, and finally deploying it using Docker Compose with Nginx as a reverse proxy.


# Task 1: Run Strapi Application Locally

In this task, we initialize and run a Strapi application using `npx`. This step is ideal for development and understanding how Strapi works before moving to containers.

```bash
# Create a new Strapi project
npx create-strapi-app@latest my-strapi-project --quickstart

# Move into the project directory
cd my-strapi-project

# Start the application in development mode
npm run develop
```

# Task 2: Containerize the Strapi Application

## In this task, we containerize the Strapi application to run it in any environment. This ensures consistency across development, staging, and production environments.

## Build the Docker image
```bash
docker build -t strapi-app .
```

## Run the container
```bash
docker run -p 1337:1337 strapi-app
```

# Task 3: Deploy Strapi with Nginx Reverse Proxy Using Docker Compose
## This task sets up Strapi behind an Nginx reverse proxy using Docker Compose. Nginx forwards traffic from port 81 to Strapi, improving flexibility and scalability.

## Start the services using Docker Compose
```bash
docker-compose up --build
```

# Task 4: Automating Strapi Deployment with Terraform on EC2
In this task, the goal is to automate the complete deployment of a Strapi application using Terraform. Terraform  provisions an EC2 instance running Ubuntu, which automatically installs Node.js, npm, and Strapi CLI.
It then creates a new Strapi project, installs the necessary dependencies, builds the admin panel, and starts the 
development server — all without requiring manual SSH access or commands.
This setup ensures a fully functional Strapi instance is available as soon as the EC2 instance is up and running.


# Task-5: Deploy Strapi on EC2 Using Terraform and Docker
**In this task, the objective is to automate the deployment of a containerized Strapi application on an EC2 instance using Terraform. The process ensures that the EC2 instance is provisioned, Docker is installed, and the Strapi app is automatically launched inside a container without requiring any manual intervention.***

**We assume that the Strapi application has already been containerized and the image is available on Docker Hub or ECR. Terraform is used to provision the infrastructure and execute a user-data script that handles Docker installation and Strapi container setup.**

**Key Steps:**
 - **Provision EC2 instance using Terraform.**

 - **Use a user-data script to:**

 - **Install Docker.**

 - **Pull the pre-built Strapi Docker image.**

 - **Run the container on port 1337.**

 - **This setup ensures that once the EC2 instance is created, the Strapi app becomes accessible via the instance's public IP without any manual SSH or command execution.**

# Task-6: Automate Strapi Deployment with GitHub Actions
**In this task, we automate the entire workflow of containerizing a Strapi application, pushing the image to Docker Hub, and provisioning infrastructure on AWS using Terraform — all through GitHub Actions.**

### The GitHub Actions workflow includes:

1. **Building the Docker image of the Strapi application.**

2. **Pushing the Docker image to Docker Hub.**

3. **Running Terraform to provision an EC2 instance, install Docker, and deploy the Strapi container.**

**This ensures a complete CI/CD pipeline where any changes pushed to the repository automatically trigger the build and deployment process.**

### GitHub Actions Workflow Summary:
 - **Triggered on every push to the main branch.**

 - **Builds the Docker image from the Strapi source code.**

 - **Authenticates and pushes the image to Docker Hub.**

 - **Initializes and applies the Terraform configuration to:**

     - **Launch an EC2 instance.**

     - **Execute user-data script to install Docker.**

     - **Pull and run the new Docker image as a container.**

**With this workflow in place, deployment becomes fully automated — from code changes to live infrastructure.**

# Task-7: Deploy Strapi on AWS ECS Fargate via Terraform and GitHub Actions (CI/CD)

This task involves deploying a Strapi application on AWS using ECS Fargate. The entire infrastructure is provisioned and managed through Terraform, and the build, push, and deployment processes are automated via GitHub Actions.

---

## 🚀 Objective

To containerize the Strapi application, push the image to Docker Hub, and automate the provisioning of ECS Fargate infrastructure using Terraform. CI/CD is implemented through GitHub Actions to ensure seamless deployment on code changes.

---

## 📦 Steps Involved

### 1. Containerize the Strapi Application

We use a Dockerfile located in the root of the repository to build a Docker image for the Strapi application.

```bash
docker build -t <your-dockerhub-username>/strapi:<tag> .
```
### 2. Provision ECS Fargate Infrastructure Using Terraform
Terraform code is located in the terraform/ directory and handles:

 - **VPC and networking**

 - **ECS Cluster and Fargate service**

 - **Task definitions pointing to the Docker image**

 - **Load balancer for public access**

### 3. Automate with GitHub Actions
**A GitHub Actions workflow file (.github/workflows/deploy.yml) automates the full process:**

 - **Builds the Docker image from the latest commit**

 - **Pushes it to Docker Hub**

 - **Applies the Terraform infrastructure with the new image**

The workflow uses Terraform's -var="docker_image=..." flag to pass the image to ECS.

# Task 8: Deploy Strapi on AWS ECS Fargate with GitHub Actions and CloudWatch Monitoring

## Overview

This task automates the deployment of a Strapi application on AWS ECS Fargate using Terraform and GitHub Actions. It avoids using remote backends like S3 or DynamoDB and uses the local state instead. Additionally, CloudWatch is configured for centralized logging and basic metric collection.

---

## GitHub Actions Workflow

The CI/CD pipeline is automated with GitHub Actions, which:

- Builds the Docker image
- Pushes the image to Docker Hub
- Initializes and applies the Terraform configuration to:
  - Launch ECS Fargate resources
  - Create necessary networking components
  - Deploy the containerized Strapi app

---

## CloudWatch Integration

Terraform also sets up:

- A CloudWatch Log Group `/ecs/strapi`
- ECS task logging using the AWS `awslogs` log driver
- Basic ECS metrics like CPU and Memory usage

> You can optionally enhance this with CloudWatch dashboards or alarms for performance monitoring.

---

2. **Trigger the GitHub Action.**  
   - This will build the Docker image, push it to Docker Hub, and apply Terraform to deploy ECS infra.

---

## How to Destroy the Infrastructure

Use a separate GitHub Actions workflow that runs `terraform destroy -auto-approve`.  
It reads the local `terraform.tfstate` file (so don't delete it until teardown is complete).

---

## Requirements

- Terraform CLI
- AWS Account with ECS/Fargate permissions
- GitHub repository with secrets configured
- Dockerfile at root of project
- Terraform code inside `terraform/` folder

---

## Notes

- This setup uses **local state** (`terraform.tfstate`) and does **not require** S3 or DynamoDB.
- It is intended for one-time or demo use. For production, use S3 and DynamoDB for state locking and consistency.

# Task 9: Deploy Strapi on AWS ECS Fargate Spot with CloudWatch Monitoring

This task focuses on deploying a Strapi application using **AWS ECS Fargate Spot instances**, provisioned through **Terraform**, and automated using **GitHub Actions**. The deployment includes centralized **CloudWatch logging** and ECS-level metrics monitoring.

---

## 📌 Task Overview

Strapi, a headless CMS, is containerized and deployed as an ECS Fargate service using cost-effective Fargate Spot capacity. Terraform manages the infrastructure while GitHub Actions automates the pipeline from Docker image build to deployment.

---

## ✅ What This Task Covers

1. **Create ECS Cluster and Fargate Task Definition** for Strapi.
2. **Use FARGATE_SPOT** as the launch strategy to reduce cost.
3. **Reference pre-existing IAM role** (`ecsTaskExecutionRole`) for permissions.
4. **Configure CloudWatch Logs** with `/ecs/strapi` log group and `awslogs` driver.
5. **Deploy ECS Service** with public IP assignment for browser access.
6. **CI/CD** is managed through GitHub Actions to:
   - Build and push Docker image to Docker Hub
   - Apply Terraform configuration automatically

# 📦 Task-10: Host and Publish Strapi Project on AWS ECS Fargate

This task involves hosting a Strapi application deployed on AWS ECS Fargate and publishing content through the Strapi Admin Panel. After deploying, you can access public APIs via the ALB (Application Load Balancer) DNS URL.

---

## 🔗 Admin Panel Access

Visit the Strapi Admin Panel at:


> Replace `<alb-dns-name>` with the DNS of your Application Load Balancer from AWS.

---

## 🚀 Steps to Host and Publish Content

### 1. Log in to Strapi Admin
- Open the admin panel URL.
- Sign up as a new admin or log in with existing credentials.

---

### 2. Create Content Types
- Navigate to **Content-Type Builder**.
- Choose **Collection Type** or **Single Type**.
- Define your content structure (e.g., blog with title, content, etc.).
- Save and allow Strapi to restart.

---

### 3. Configure Public Access
- Go to **Settings > Roles & Permissions Plugin > Roles**.
- Select the **Public** role.
- Enable the following permissions for your content type:
  - `find`
  - `findOne`
- Click **Save**.

> ⚠️ Public role grants open access to the APIs. Configure with caution.

---

### 4. Manage Content
- Go to **Content Manager**.
- Choose your content type (e.g., blogs).
- Click **Add New Entry**.
- Fill in content and click **Publish**.

---

### 5. Access Public API
Use the following format to access your public API endpoint:

## ✅ Status

- [x] Strapi Hosted on AWS ECS Fargate
- [x] Admin Access Configured
- [x] Content Types Created
- [x] Public APIs Enabled