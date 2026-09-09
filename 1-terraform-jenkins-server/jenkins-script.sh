#!/bin/bash

set -e

# ==========================================
# Update system
# ==========================================

dnf update -y


# ==========================================
# Install required packages
# ==========================================

dnf install -y \
  java-21-amazon-corretto \
  git \
  wget \
  curl \
  unzip \
  tar \
  gzip \
  fontconfig \
  awscli


# ==========================================
# Install Jenkins
# ==========================================

wget -O /etc/yum.repos.d/jenkins.repo \
  https://pkg.jenkins.io/rpm-stable/jenkins.repo

rpm --import https://pkg.jenkins.io/rpm-stable/jenkins.io-2026.key

dnf upgrade -y

dnf install -y jenkins

systemctl daemon-reload
systemctl enable jenkins
systemctl start jenkins


# ==========================================
# Install Terraform
# ==========================================

dnf install -y yum-utils

yum-config-manager \
  --add-repo \
  https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo

dnf install -y terraform


# ==========================================
# Install kubectl for Kubernetes 1.35
# ==========================================

KUBECTL_VERSION=$(curl -L -s https://dl.k8s.io/release/stable-1.35.txt)

curl -LO \
  "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl"

install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

rm -f kubectl


# ==========================================
# Verify installations
# ==========================================

echo "=========================================="
echo "Java version"
echo "=========================================="
java -version

echo "=========================================="
echo "Git version"
echo "=========================================="
git --version

echo "=========================================="
echo "Terraform version"
echo "=========================================="
terraform version

echo "=========================================="
echo "kubectl version"
echo "=========================================="
kubectl version --client

echo "=========================================="
echo "AWS CLI version"
echo "=========================================="
aws --version

echo "=========================================="
echo "Jenkins status"
echo "=========================================="
systemctl status jenkins --no-pager

echo "=========================================="
echo "Jenkins server setup completed"
echo "=========================================="