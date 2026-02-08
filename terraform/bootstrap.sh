#!/bin/bash
set -euxo pipefail

exec > >(tee /var/log/bootstrap.log) 2>&1

# -----------------------------
# System update
# -----------------------------
dnf update -y

# -----------------------------
# Docker
# -----------------------------
dnf install -y docker
systemctl enable docker
systemctl start docker
usermod -aG docker ec2-user

# -----------------------------
# DevOps user (LAB ONLY)
# -----------------------------
useradd devops || true
echo "devops:devops123" | chpasswd
usermod -aG wheel,docker devops

echo "devops ALL=(ALL) NOPASSWD:ALL" >/etc/sudoers.d/devops
chmod 440 /etc/sudoers.d/devops

# Enable SSH password auth (LAB ONLY)
sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/^#PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
systemctl restart sshd

# -----------------------------
# Java 17 (STANDARD)
# -----------------------------
dnf install -y java-17-amazon-corretto
#alternatives --set java /usr/lib/jvm/java-17-amazon-corretto/bin/java

# -----------------------------
# Git + Maven
# -----------------------------
dnf install -y git maven

# -----------------------------
# Jenkins
# -----------------------------
wget -O /etc/yum.repos.d/jenkins.repo \
  https://pkg.jenkins.io/redhat-stable/jenkins.repo

rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key

dnf install -y jenkins

# Jenkins port override
mkdir -p /etc/systemd/system/jenkins.service.d

cat <<EOF >/etc/systemd/system/jenkins.service.d/override.conf
[Service]
Environment="JENKINS_PORT=8081"
EOF

systemctl daemon-reexec
systemctl daemon-reload
systemctl enable jenkins
systemctl start jenkins

# Jenkins Docker access
usermod -aG docker jenkins

# -----------------------------
# AWS CLI
# -----------------------------
dnf install -y awscli

# -----------------------------
# kubectl
# -----------------------------
curl -o /usr/local/bin/kubectl \
https://s3.us-west-2.amazonaws.com/amazon-eks/1.32.0/2024-12-20/bin/linux/amd64/kubectl
chmod +x /usr/local/bin/kubectl

# -----------------------------
# eksctl
# -----------------------------
ARCH=amd64
PLATFORM=$(uname -s)_$ARCH
curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_$PLATFORM.tar.gz"
tar -xzf eksctl_$PLATFORM.tar.gz -C /tmp
mv /tmp/eksctl /usr/local/bin
rm -f eksctl_$PLATFORM.tar.gz

# -----------------------------
# Helm
# -----------------------------
curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# -----------------------------
# Trivy
# -----------------------------
# cat <<EOF >/etc/yum.repos.d/trivy.repo
# [trivy]
# name=Trivy
# baseurl=https://aquasecurity.github.io/trivy-repo/rpm/releases/\$basearch/
# enabled=1
# gpgcheck=1
# gpgkey=https://aquasecurity.github.io/trivy-repo/rpm/public.key
# EOF

# dnf install -y trivy

# # -----------------------------
# # SonarQube REQUIREMENTS
# # -----------------------------

# # Kernel tuning for Elasticsearch
# sysctl -w vm.max_map_count=262144
# echo "vm.max_map_count=262144" >> /etc/sysctl.conf

# # Docker network
# docker network create sonar-net || true

# # PostgreSQL (REQUIRED)
# docker run -d \
#   --name sonar-postgres \
#   --network sonar-net \
#   --restart unless-stopped \
#   -e POSTGRES_USER=sonar \
#   -e POSTGRES_PASSWORD=sonar \
#   -e POSTGRES_DB=sonarqube \
#   -v sonar_pg_data:/var/lib/postgresql/data \
#   postgres:15

# # SonarQube volumes
# docker volume create sonarqube_data
# docker volume create sonarqube_extensions
# docker volume create sonarqube_logs

# # SonarQube server
# docker run -d \
#   --name sonarqube \
#   --network sonar-net \
#   --restart unless-stopped \
#   -p 9000:9000 \
#   -e SONAR_JDBC_URL=jdbc:postgresql://sonar-postgres:5432/sonarqube \
#   -e SONAR_JDBC_USERNAME=sonar \
#   -e SONAR_JDBC_PASSWORD=sonar \
#   -v sonarqube_data:/opt/sonarqube/data \
#   -v sonarqube_extensions:/opt/sonarqube/extensions \
#   -v sonarqube_logs:/opt/sonarqube/logs \
#   sonarqube:9.9-community


# curl -L https://github.com/gitleaks/gitleaks/releases/download/v8.18.2/gitleaks_8.18.2_linux_x64.tar.gz \
# -o /tmp/gitleaks.tar.gz && tar -xzf /tmp/gitleaks.tar.gz -C /tmp && sudo mv /tmp/gitleaks /usr/local/bin/ \
# && sudo chmod +x /usr/local/bin/gitleaks
# curl -sSL https://github.com/gitleaks/gitleaks/releases/latest/download/gitleaks-linux-amd64 \
#   -o /usr/local/bin/gitleaks
# chmod +x /usr/local/bin/gitleaks

echo "BOOTSTRAP COMPLETED – REBOOTING"

reboot
