
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