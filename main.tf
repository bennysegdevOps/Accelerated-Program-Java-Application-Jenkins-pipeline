# VPC
resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = "${local.name}-vpc"
  }
}

# Public Subnet 
resource "aws_subnet" "public_subnet1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.pub_sub1_cidr
  availability_zone = var.availability_zone_1

  tags = {
    Name = "${local.name}-public_subnet1"
  }
}

resource "aws_subnet" "public_subnet2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.pub_sub2_cidr
  availability_zone = var.availability_zone_2

  tags = {
    Name = "${local.name}-public_subnet2"
  }
}

resource "aws_subnet" "private_subnet1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.priv_sub1_cidr
  availability_zone = var.availability_zone_1

  tags = {
    Name = "${local.name}-private_subnet1"
  }
}

resource "aws_subnet" "private_subnet2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.priv_sub2_cidr
  availability_zone = var.availability_zone_2

  tags = {
    Name = "${local.name}-private_subnet2"
  }
}

# Internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${local.name}-igw"
  }
}

# # elastic ip
# resource "aws_eip" "nat_eip" {
#   vpc                       = true
#   depends_on = [aws_internet_gateway.igw]
# }

# # NAT gateway
# resource "aws_nat_gateway" "natgw" {
#   allocation_id = aws_eip.nat_eip.id
#   subnet_id     = aws_subnet.public_subnet1.id

#   tags = {
#     Name = "${local.name}-natgw"
#   }
# }

# Public Route Table
resource "aws_route_table" "public_RT" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = var.RT_cidr
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${local.name}-public_RT"
  }
}

# Private Route Table
# resource "aws_route_table" "private_RT" {
#   vpc_id = aws_vpc.main.id

#   route {
#     cidr_block = var.RT_cidr
#     gateway_id = aws_nat_gateway.natgw.id
#   }

#   tags = {
#     Name = "${local.name}-private_RT"
#   }
# }

# Public Route Table Association 
resource "aws_route_table_association" "public_subnet1" {
  subnet_id      = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.public_RT.id
}

resource "aws_route_table_association" "public_subnet2" {
  subnet_id      = aws_subnet.public_subnet2.id
  route_table_id = aws_route_table.public_RT.id
}

# Private Route Table Association 
# resource "aws_route_table_association" "private_subnet1" {
#   subnet_id      = aws_subnet.private_subnet1.id
#   route_table_id = aws_route_table.private_RT.id
# }

# resource "aws_route_table_association" "private_subnet2" {
#   subnet_id      = aws_subnet.private_subnet2.id
#   route_table_id = aws_route_table.private_RT.id
# }

# Security Group for Bastion Host and Ansible Server
resource "aws_security_group" "Bastion-Ansible_SG" {
  name        = "${local.name}-Bastion-Ansible"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "Allow ssh access"
    from_port        = var.port_ssh
    to_port          = var.port_ssh
    protocol         = "tcp"
    cidr_blocks      = [var.RT_cidr]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [var.RT_cidr]
  }

  tags = {
    Name = "${local.name}-Bastion-Ansible-SG"
  }
}

# Security Group for Docker Server
resource "aws_security_group" "Docker_SG" {
  name        = "${local.name}-Docker"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "Allow ssh access"
    from_port        = var.port_ssh
    to_port          = var.port_ssh
    protocol         = "tcp"
    cidr_blocks      = [var.RT_cidr]
  }

  ingress {
    description      = "Allow proxy access"
    from_port        = var.port_proxy
    to_port          = var.port_proxy
    protocol         = "tcp"
    cidr_blocks      = [var.RT_cidr]
  }

  ingress {
    description      = "Allow http access"
    from_port        = var.port_http
    to_port          = var.port_http
    protocol         = "tcp"
    cidr_blocks      = [var.RT_cidr]
  }

  ingress {
    description      = "Allow https access"
    from_port        = var.port_https
    to_port          = var.port_https
    protocol         = "tcp"
    cidr_blocks      = [var.RT_cidr]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [var.RT_cidr]
  }

  tags = {
    Name = "${local.name}-Docker-SG"
  }
}

# Security Group for Jenkins Server
resource "aws_security_group" "Jenkins_SG" {
  name        = "${local.name}-Jenkins"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "Allow ssh access"
    from_port        = var.port_ssh
    to_port          = var.port_ssh
    protocol         = "tcp"
    cidr_blocks      = [var.RT_cidr]
  }

  ingress {
    description      = "Allow proxy access"
    from_port        = var.port_proxy
    to_port          = var.port_proxy
    protocol         = "tcp"
    cidr_blocks      = [var.RT_cidr]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [var.RT_cidr]
  }

  tags = {
    Name = "${local.name}-Jenkins-SG"
  }
}

# Security Group for Sonarqube Server
resource "aws_security_group" "Sonarqube_SG" {
  name        = "${local.name}-Sonarqube"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "Allow ssh access"
    from_port        = var.port_ssh
    to_port          = var.port_ssh
    protocol         = "tcp"
    cidr_blocks      = [var.RT_cidr]
  }

  ingress {
    description      = "Allow sonarqube access"
    from_port        = var.port_sonar
    to_port          = var.port_sonar
    protocol         = "tcp"
    cidr_blocks      = [var.RT_cidr]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [var.RT_cidr]
  }

  tags = {
    Name = "${local.name}-Sonarqube-SG"
  }
}

# # Security Group for Nexus Server
# resource "aws_security_group" "Nexus_SG" {
#   name        = "${local.name}-Nexus"
#   description = "Allow inbound traffic"
#   vpc_id      = aws_vpc.main.id

#   ingress {
#     description      = "Allow ssh access"
#     from_port        = var.port_ssh
#     to_port          = var.port_ssh
#     protocol         = "tcp"
#     cidr_blocks      = [var.RT_cidr]
#   }

#   ingress {
#     description      = "Allow nexus access"
#     from_port        = var.port_proxy_nex
#     to_port          = var.port_proxy_nex
#     protocol         = "tcp"
#     cidr_blocks      = [var.RT_cidr]
#   }

#   egress {
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1"
#     cidr_blocks      = [var.RT_cidr]
#   }

#   tags = {
#     Name = "${local.name}-Nexus-SG"
#   }
# }

# # Security Group for MySQL RDS Database
# resource "aws_security_group" "MySQL_RDS_SG" {
#   name        = "${local.name}-MySQL-RDS"
#   description = "Allow inbound traffic"
#   vpc_id      = aws_vpc.main.id

#   ingress {
#     description      = "Allow MySQL access"
#     from_port        = var.port_mysql
#     to_port          = var.port_mysql
#     protocol         = "tcp"
#     cidr_blocks      = [var.RT_cidr]
#   }

#   egress {
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1"
#     cidr_blocks      = [var.RT_cidr]
#   }

#   tags = {
#     Name = "${local.name}-MySQL-SG"
#   }
# }

# keypair
resource "aws_key_pair" "benny_keypair" {
  key_name   = var.key_name
  public_key = file(var.keypair_path)
}

# # bastion host ubuntu instance 
# resource "aws_instance" "bastion-host" {
#   ami                             = var.ami # ubuntu # eu-west-1
#   instance_type                   = var.instance_type
#   key_name                        = aws_key_pair.benny_keypair.key_name
#   vpc_security_group_ids          = [aws_security_group.Bastion-Ansible_SG.id]
#   associate_public_ip_address     = true
#   subnet_id                       = aws_subnet.public_subnet2.id
#   user_data                       = <<-EOF
#   #!/bin/bash
#   echo "${var.private_keypair_path}" >> /home/ubuntu/benny
#   sudo chmod 400 benny
#   sudo hostname bastion-host
#   EOF

#   tags = {
#     Name = "${local.name}-bastion-host"
#   }
# }

# ansible ubuntu instance 
resource "aws_instance" "ansible-server" {
  ami                                 = var.ami2 # red hat # eu-west-1
  instance_type                       = var.instance_type
  key_name                            = aws_key_pair.benny_keypair.key_name
  vpc_security_group_ids              = [aws_security_group.Bastion-Ansible_SG.id]
  associate_public_ip_address         = true
  subnet_id                           = aws_subnet.public_subnet2.id
  user_data                           = local.ansible_user_data
  
  tags = {
    Name = "${local.name}-ansible-server"
  }
}

# docker ubuntu instance 
resource "aws_instance" "docker-server" {
  ami                           = var.ami2 # red hat # eu-west-1
  instance_type                 = var.instance_type
  key_name                      = aws_key_pair.benny_keypair.key_name
  vpc_security_group_ids        = [aws_security_group.Docker_SG.id]
  associate_public_ip_address   = true
  subnet_id                     = aws_subnet.public_subnet1.id
  user_data                     = local.docker_user_data
 
  tags = {
    Name = "${local.name}-docker-server"
  }
}

# jenkins ubuntu instance 
resource "aws_instance" "jenkins-server" {
  ami                         = var.ami2 # red hat # eu-west-1
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.benny_keypair.key_name
  vpc_security_group_ids      = [aws_security_group.Jenkins_SG.id]
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.public_subnet1.id
  user_data                   = local.jenkins_user_data

  tags = {
    Name = "${local.name}-jenkins-server"
  }
}

# sonarqube ubuntu instance 
resource "aws_instance" "sonarqube-server" {
  ami                         = var.ami # ubuntu # eu-west-1
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.benny_keypair.id
  vpc_security_group_ids      = [aws_security_group.Sonarqube_SG.id]
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.public_subnet1.id
  user_data                   = local.sonarqube_user_data

  tags = {
    Name = "${local.name}-sonarqube-server"
  }
}

# # nexus ubuntu instance 
# resource "aws_instance" "nexus-server" {
#   ami                         = var.ami2 # red hat # eu-west-1
#   instance_type               = var.instance_type
#   key_name                    = aws_key_pair.benny_keypair.id
#   vpc_security_group_ids      = [aws_security_group.Nexus_SG.id]
#   associate_public_ip_address = true
#   subnet_id                   = aws_subnet.public_subnet2.id
#   user_data                   = local.nexus_user_data 

#   tags = {
#     Name = "${local.name}-nexus-server"
#   }
# }

# # database subnet group
# resource "aws_db_subnet_group" "db-subnet" {
#   name       = "${local.name}-db-subnet-group"
#   subnet_ids = [aws_subnet.private_subnet1.id, aws_subnet.private_subnet2.id]

#   tags = {
#     Name = "${local.name}-db-subnet-group"
#     }
# }
