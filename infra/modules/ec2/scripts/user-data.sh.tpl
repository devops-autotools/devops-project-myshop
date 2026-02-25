#!/bin/bash
set -e
exec > /var/log/user-data.log 2>&1

echo "===== START USER DATA ====="

# Detect OS
if [ -f /etc/os-release ]; then
  . /etc/os-release
  OS=$ID
else
  echo "Cannot detect OS"
  exit 1
fi

echo "Detected OS: $OS"

#####################################
# Install Docker based on OS
#####################################

install_docker_redhat() {
  echo "Installing Docker on RHEL/CentOS/Amazon Linux"

  yum update -y
  yum install -y docker git curl

  systemctl start docker
  systemctl enable docker
}

install_docker_ubuntu() {
  echo "Installing Docker on Ubuntu/Debian"

  apt update -y
  apt install -y docker.io git curl

  systemctl start docker
  systemctl enable docker
}

case "$OS" in
  amzn|rhel|centos)
    install_docker_redhat
    ;;
  ubuntu|debian)
    install_docker_ubuntu
    ;;
  *)
    echo "Unsupported OS: $OS"
    exit 1
    ;;
esac

#####################################
# Install Docker Compose v2
#####################################

mkdir -p /usr/local/lib/docker/cli-plugins

curl -SL https://github.com/docker/compose/releases/latest/download/docker-compose-linux-$(uname -m) \
  -o /usr/local/lib/docker/cli-plugins/docker-compose

chmod +x /usr/local/lib/docker/cli-plugins/docker-compose

docker compose version

#####################################
# Clone and Run App
#####################################

cd /home/${default_user}

git clone ${repo_url}

cd ${repo_name}

docker compose up -d

echo "===== USER DATA COMPLETED ====="
