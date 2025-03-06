#!/bin/bash

# Function to check if a package is installed
is_package_installed() {
    dpkg -l | grep -q $1
}

# Function to install a package if it's not already installed
install_package() {
    if ! is_package_installed $1; then
        echo "Installing $1..."
        sudo apt-get install -y $1
    else
        echo "$1 is already installed."
    fi
}

# Update package list
echo "Updating package list..."
sudo apt-get update

# Install dependencies
echo "Checking and installing dependencies..."
install_package "apt-transport-https"
install_package "ca-certificates"
install_package "curl"
install_package "software-properties-common"

# Add Docker’s official GPG key
echo "Adding Docker's official GPG key..."
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc

# Add Docker repository
echo "Adding Docker repository..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update package list again
echo "Updating package list again..."
sudo apt-get update

# Install Docker
echo "Installing Docker..."
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Start and enable Docker service
echo "Starting and enabling Docker service..."
sudo systemctl start docker
sudo systemctl enable docker

# Verify Docker service is up and running
echo "Verifying Docker service status..."
if sudo systemctl is-active --quiet docker; then
    echo "Docker service is up and running."
else
    echo "Docker service is not running. Please check the logs for more information."
    exit 1
fi

# Verify Docker installation by running a test container
echo "Verifying Docker installation by running a test container..."
sudo docker run hello-world

# Check if the test container ran successfully
if [ $? -eq 0 ]; then
    echo "Docker installation verified successfully."
else
    echo "Docker installation verification failed."
    exit 1
fi

echo "Docker installation and verification completed successfully."