locals {
  docker_user_data = <<-EOF
#!/bin/bash
sudo yum update -y
sudo yum upgrade -y
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install docker-ce -y
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker ec2-user
sudo mkdir /opt/docker
sudo chown -R ec2-user:ec2-user /opt/
cd /opt/
sudo chmod 600 /opt/docker
sudo hostnamectl set-hostname Docker
EOF
}