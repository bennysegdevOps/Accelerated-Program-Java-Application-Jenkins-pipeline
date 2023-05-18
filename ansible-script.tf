locals {
  ansible_user_data = <<-EOF
#!/bin/bash

# updating and installing wget, ansible, python dependences for ansible
sudo yum update -y
sudo yum install wget -y
wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo yum install epel-release-latest-7.noarch.rpm -y
sudo yum update -y
sudo yum install git python python-devel python-pip ansible -y

# install docker
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install docker-ce -y
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker ec2-user

# giving right permission to the /etc/ansible directory
sudo chown -R ec2-user:ec2-user /etc/ansible
echo "${var.private_keypair_path}" >> /home/ec2-user/benny.pem
chmod 400 benny.pem
cd /etc/ansible
touch hosts
sudo chown ec2-user:ec2-user hosts

# Update our hosts inventory file
cat <<EOT> /etc/ansible/hosts
[all:vars]
ansible_ssh_common_args='-o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no'

localhost ansible_connection=local

[docker_host]
${aws_instance.docker-server.public_ip} ansible_user=ec2-user ansible_ssh_private_key_file=/home/ec2-user/benny.pem
EOT
sudo mkdir /opt/docker

# create Dockerfile to convert artifact to an image
touch /opt/docker/Dockerfile
cat <<EOT>> /opt/docker/Dockerfile
FROM tomcat
FROM openjdk:8-jre-slim
COPY *.war app/
WORKDIR app/
ENTRYPOINT [ "java", "-jar", "spring-petclinic-1.0.war", "--server.port=8080"]
EOT

# create yaml file to build docker image
touch /opt/docker/docker-image.yml
cat <<EOT>> /opt/docker/docker-image.yml
---
 - hosts: localhost
   become: true

   tasks:

   - name: login to dockerhub
     command: docker login -u cloudhight -p CloudHight_Admin123@

   - name: Create docker image from Pet Adoption war file
     command: docker build -t testapp .
     args:
       chdir: /opt/docker

   - name: Add tag to image
     command: docker tag testapp cloudhight/testapp

   - name: Push image to docker hub
     command: docker push cloudhight/testapp

   - name: Remove docker image from Ansible node
     command: docker rmi testapp cloudhight/testapp
     ignore_errors: yes
EOT

# Create yaml file to build container using image
touch /opt/docker/docker-container.yml
cat <<EOT>> /opt/docker/docker-container.yml
---
 - hosts: docker_host
   become: true

   tasks:
   - name: login to dockerhub
     command: docker login -u cloudhight -p CloudHight_Admin123@

   - name: Stop any container running
     command: docker stop testAppContainer
     ignore_errors: yes

   - name: Remove stopped container
     command: docker rm testAppContainer
     ignore_errors: yes

   - name: Remove docker image
     command: docker rmi cloudhight/testapp
     ignore_errors: yes

   - name: Pull docker image from dockerhub
     command: docker pull cloudhight/testapp

   - name: Create container from pet adoption image
     command: docker run -it -d --name testAppContainer -p 8080:8080 cloudhight/testapp
EOT

# Create yaml file to create a newrelic container
cat << EOT > /opt/docker/newrelic.yml
---
 - hosts: docker_host
   become: true

   tasks:
   - name: install newrelic agent
     command: docker run \\
                     -d \\
                     --name newrelic-infra \\
                     --network=host \\
                     --cap-add=SYS_PTRACE \\
                     --privileged \\
                     --pid=host \\
                     -v "/:/host:ro" \\
                     -v "/var/run/docker.sock:/var/run/docker.sock" \\
                     -e NRIA_LICENSE_KEY=c605530d3bdfc50e00542ec7f199be7efebaNRAL \\
                     newrelic/infrastructure:latest
EOT

sudo chown -R ec2-user:ec2-user /opt/docker
sudo chmod -R 700 /opt/docker
echo "license_key: c605530d3bdfc50e00542ec7f199be7efebaNRAL" | sudo tee -a /etc/newrelic-infra.yml
sudo curl -o /etc/yum.repos.d/newrelic-infra.repo https://download.newrelic.com/infrastructure_agent/linux/yum/el/7/x86_64/newrelic-infra.repo
sudo yum -q makecache -y --disablerepo='*' --enablerepo='newrelic-infra'
sudo yum install newrelic-infra -y --nobest
EOF
}