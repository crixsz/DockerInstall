#!/bin/bash
clear
echo "Starting Docker Installation..."
# Function to install Docker on Ubuntu 20.04
install_docker_ubuntu() {
  sudo apt-get update
  sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  sudo add-apt-repository "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
  sudo apt-get update
  sudo apt-get install -y docker-ce docker-ce-cli containerd.io
  sudo systemctl enable docker
  sudo systemctl start docker
}

# Function to install Docker on Debian 10
install_docker_debian() {
  sudo apt-get update
  sudo apt-get install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common
  curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt-get update
  sudo apt-get install -y docker-ce docker-ce-cli containerd.io
  sudo systemctl enable docker
  sudo systemctl start docker
}

# Check if the system is running Debian 10 or Ubuntu 20.04
if [[ "$(lsb_release -is)" == "Debian" && "$(lsb_release -rs)" == "10" ]]; then
  install_docker_debian
elif [[ "$(lsb_release -is)" == "Ubuntu" && "$(lsb_release -rs)" == "20.04" ]]; then
  install_docker_ubuntu
else
  echo "This script only supports Debian 10 and Ubuntu 20.04."
  exit 1
fi

# Optionally add the current user to the Docker group
read -p "Do you want to add the current user to the Docker group? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  sudo usermod -aG docker $USER
  echo "You may need to log out and log back in for the group changes to take effect."
fi
