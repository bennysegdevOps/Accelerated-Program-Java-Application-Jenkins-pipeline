# ansible server public ip 
output "ansible_ip" {
  value = aws_instance.ansible-server.public_ip
}

# docker server private ip 
output "docker_ip" {
  value = aws_instance.docker-server.public_ip
}

# jenkins server public ip 
output "jenkins_ip" {
  value = aws_instance.jenkins-server.public_ip
}

# sonarqube server public ip 
output "sonarqube_ip" {
  value = aws_instance.sonarqube-server.public_ip
}

# nexus server public ip 
output "nexus_ip" {
  value = aws_instance.nexus-server.public_ip
}