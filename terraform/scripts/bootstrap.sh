#!/bin/bash

# Update the package list
sudo apt-get update -y

# Install Docker
sudo apt-get install -y docker.io

# Enable Docker service
sudo systemctl enable docker
sudo systemctl start docker

# Add the ubuntu user to the docker group
sudo usermod -aG docker ubuntu

# Install Docker Compose
sudo apt-get install -y docker-compose

# Copy the necessary files from the /home/ubuntu/scripts directory to the project directory
mkdir -p /home/ubuntu/goodgame

