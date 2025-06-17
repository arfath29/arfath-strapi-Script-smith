#!/bin/bash
# Update system and install Docker
apt-get update -y
apt-get install -y docker.io

# Start Docker service
systemctl start docker
systemctl enable docker

# Allow ubuntu user to run docker without sudo
usermod -aG docker ubuntu

# Pull and run the Strapi Docker image
docker pull arfath29/strapi

# Run Strapi container
docker run -d -p 1337:1337 --name strapi-app arfath29/strapi
