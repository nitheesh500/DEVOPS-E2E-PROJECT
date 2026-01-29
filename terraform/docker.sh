#!/bin/bash
set -e

# -----------------------------
# System update
# -----------------------------
dnf update -y

# -----------------------------
# Install Docker
# -----------------------------
dnf install -y dnf-plugins-core
dnf config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo
dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

systemctl enable docker
systemctl start docker

usermod -aG docker ec2-user

# -----------------------------
# Install Java (for Jenkins & builds)
# -----------------------------
dnf install -y java-17-amazon-corretto

# -----------------------------
# Install Jenkins
# -----------------------------
wget -O /etc/yum.repos.d/jenkins.repo \
  https://pkg.jenkins.io/redhat-stable/jenkins.repo

rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

dnf install -y jenkins

systemctl enable jenkins
systemctl start jenkins

usermod -aG docker jenkins

# -----------------------------
# Install AWS CLI
# -----------------------------
dnf install -y awscli

# -----------------------------
# Install kubectl
# -----------------------------
curl -LO https://s3.us-west-2.amazonaws.com/amazon-eks/1.32.0/2024-12-20/bin/linux/amd64/kubectl
chmod +x kubectl
mv kubectl /usr/local/bin/kubectl

# -----------------------------
# Install eksctl
# -----------------------------
ARCH=amd64
PLATFORM=$(uname -s)_$ARCH
curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_$PLATFORM.tar.gz"
tar -xzf eksctl_$PLATFORM.tar.gz -C /tmp
mv /tmp/eksctl /usr/local/bin
rm eksctl_$PLATFORM.tar.gz

# -----------------------------
# Install Helm
# -----------------------------
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
rm get_helm.sh

# -----------------------------
# Reboot (important for docker group)
# -----------------------------
reboot
