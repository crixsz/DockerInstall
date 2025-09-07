#!/bin/bash
clear
echo "Starting Docker Installation..."

apt-get update && apt-get install -y lsb-release && apt-get clean all >> /dev/null
# Function to install Docker on Ubuntu 20.04
install_docker_ubuntu() {
  sudo apt-get update
  sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor | sudo tee /usr/share/keyrings/docker-archive-keyring.gpg > /dev/null
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt-get update
  sudo apt-get install -y docker-ce docker-ce-cli containerd.io
  sudo systemctl enable docker
  sudo systemctl start docker
}

# Function to install Docker on Debian 10
install_docker_debian() {
  apt-get update
  apt-get install -y apt-transport-https ca-certificates curl gnupg2 lsb-release
  # Add Docker's official GPG key
  curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/docker-archive-keyring.gpg > /dev/null
  # Add Docker repository for Debian 10/11
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  apt-get update
  # Try to install Docker packages
  if ! apt-get install -y docker-ce docker-ce-cli containerd.io; then
    echo "Failed to install Docker packages. Please check your network and repository configuration."
    exit 2
  fi
  systemctl enable docker
  systemctl start docker
}

# Check if the system is running Debian 10 or Ubuntu 20.04
if [[ "$(lsb_release -is)" == "Debian" ]]; then
  install_docker_debian
elif [[ "$(lsb_release -is)" == "Ubuntu" ]]; then
  install_docker_ubuntu
else
  echo "This script only supports Debian 10 and Ubuntu 20.04."
  exit 1
fi
