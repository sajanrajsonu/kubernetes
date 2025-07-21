#!/bin/bash

set -e

echo "Updating system..."
sudo apt update && sudo apt upgrade -y

echo "Installing prerequisites..."
sudo apt install -y ca-certificates curl gnupg lsb-release

echo "Adding Docker’s official GPG key..."
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
  sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo "Setting up Docker repository..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "Updating package list..."
sudo apt update

echo "Installing Docker Engine..."
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "Docker installed successfully!"
docker --version

echo "Starting Docker service..."
sudo systemctl enable docker
sudo systemctl start docker

echo "Adding user '$USER' to docker group..."
sudo usermod -aG docker $USER && newgrp docker
echo "You may need to log out and back in for group changes to take effect."

echo "Adding to docker group..."
newgrp docker
echo "You may need to log out and back in for group changes to take effect."

echo "Testing Docker..."
docker ps || echo "Run again after re-login to test 'hello-world'"
