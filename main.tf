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

# # Private Route Table
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

# # Private Route Table Association 
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

# Security Group for MySQL RDS Database
resource "aws_security_group" "MySQL_RDS_SG" {
  name        = "${local.name}-MySQL-RDS"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "Allow MySQL access"
    from_port        = var.port_mysql
    to_port          = var.port_mysql
    protocol         = "tcp"
    cidr_blocks      = [var.priv_sub1_cidr, var.priv_sub2_cidr]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [var.RT_cidr]
  }

  tags = {
    Name = "${local.name}-MySQL-SG"
  }
}

# keypair
resource "aws_key_pair" "benny_keypair" {
  key_name   = var.key_name
  public_key = file(var.keypair_path)
}

# bastion host ubuntu instance 
resource "aws_instance" "bastion-host" {
  ami                             = var.ami # ubuntu # eu-west-1
  instance_type                   = var.instance_type
  key_name                        = aws_key_pair.benny_keypair.key_name
  vpc_security_group_ids          = [aws_security_group.Bastion-Ansible_SG.id]
  associate_public_ip_address     = true
  subnet_id                       = aws_subnet.public_subnet2.id
  user_data                       = <<-EOF
  #!/bin/bash
  echo "${var.private_keypair_path}" >> /home/ubuntu/benny
  sudo chmod 400 benny
  sudo hostname bastion-host
  EOF

  tags = {
    Name = "${local.name}-bastion-host"
  }
}

# ansible red hat instance 
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

# docker red hat instance 
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

# jenkins red hat instance 
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

# # nexus red hat instance 
# resource "aws_instance" "nexus-server" {
#   ami                         = var.ami2 # red hat # eu-west-1
#   instance_type               = var.instance_type
#   key_name                    = aws_key_pair.benny_keypair.id
#   vpc_security_group_ids      = [aws_security_group.Nexus_SG.id]
#   associate_public_ip_address = true
#   subnet_id                   = aws_subnet.public_subnet2.id
  
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

# # MySQL RDS database 
# resource "aws_db_instance" "mysql_db" {
#   identifier                = var.db_identifier
#   db_subnet_group_name      = aws_db_subnet_group.db-subnet.name
#   vpc_security_group_ids    = [aws_security_group.MySQL_RDS_SG.id]
#   publicly_accessible       = false 
#   skip_final_snapshot       = true
#   allocated_storage         = 10
#   db_name                   = var.db_name
#   engine                    = var.db_engine
#   engine_version            = var.db_engine_version
#   instance_class            = var.db_instance_class
#   username                  = var.db_username
#   password                  = var.db_password
#   parameter_group_name      = var.db_parameter_gp_name
#   storage_type              = var.db_storage_type
# }

# Route 53 zone
resource "aws_route53_zone" "route53_zone" {
  name = var.domain_name
}

# Route 53 record 
resource "aws_route53_record" "wehabot" {
  zone_id = aws_route53_zone.route53_zone.id
  name    = var.domain_name
  type    = "A"
  alias {
    name                    = aws_lb.alb.dns_name
    zone_id                 = aws_lb.alb.zone_id
    evaluate_target_health  = true
  }
}

# ACM certificate # DNS Validation with Route 53 (registry)
resource "aws_acm_certificate" "acm_certificate" {
  domain_name       = var.domain_name
  # subject_alternative_names = ["*.var.domain_name"]
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

# Route53 record validation
resource "aws_route53_record" "validation_record" {
  for_each = {
    for dvo in aws_acm_certificate.acm_certificate.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }
  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.route53_zone.zone_id
}

#create acm certificate validition
resource "aws_acm_certificate_validation" "acm_certificate_validation" {
  certificate_arn         = aws_acm_certificate.acm_certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.validation_record : record.fqdn]
}

# ALB Target Group
resource "aws_lb_target_group" "target_group" {
  name     = "${local.name}-tg"
  port     = var.port_http
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

# Target Group Attachment
resource "aws_lb_target_group_attachment" "test" {
  target_group_arn = aws_lb_target_group.target_group.arn
  target_id        = aws_instance.docker-server.id
  port             = var.port_proxy
}

# ALB 
resource "aws_lb" "alb" {
  name               = "${local.name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.Docker_SG.id]
  subnets            = [aws_subnet.public_subnet1.id, aws_subnet.public_subnet2.id]
  enable_deletion_protection = false
  tags = {
  Name = "${local.name}-alb"  
  }
}

# Creating Load balancer Listener for http
resource "aws_lb_listener" "lb_listener_http" {
  load_balancer_arn      = aws_lb.alb.arn
  port                   = var.port_http
  protocol               = "HTTP"
  default_action {
    type                 = "forward"
    target_group_arn     = aws_lb_target_group.target_group.arn
    }
  }
  
# Creating a Load balancer Listener for https access
resource "aws_lb_listener" "lb_listener_https" {
  load_balancer_arn      = aws_lb.alb.arn
  port                   = var.port_https
  protocol               = "HTTPS"
  ssl_policy             = "ELBSecurityPolicy-2016-08"
  certificate_arn        = "${aws_acm_certificate.acm_certificate.arn}"
  default_action {
    type                 = "forward"
    target_group_arn     = aws_lb_target_group.target_group.arn
  }
}

# ami from instance with time sleep resource
resource "aws_ami_from_instance" "docker-ami" {
  name                        = "${local.name}-ami"
  source_instance_id          = aws_instance.docker-server.id
  snapshot_without_reboot     = true
  depends_on                  = [aws_instance.docker-server, time_sleep.docker_wait_time]
}

resource "time_sleep" "docker_wait_time" {
  depends_on = [aws_instance.docker-server] 
  create_duration = "300s"
}

# launch configuration
resource "aws_launch_configuration" "launch_config" {
  name                        = "${local.name}-lc"
  image_id                    = aws_ami_from_instance.docker-ami.id
  instance_type               = var.instance_type
  associate_public_ip_address = true
  security_groups             = [aws_security_group.Docker_SG.id]
  key_name                    = aws_key_pair.benny_keypair.key_name
  lifecycle {
    create_before_destroy     = false
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "asg" {
  name                      = "${local.name}-asg"
  max_size                  = 2
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "EC2"
  desired_capacity          = 1
  force_delete              = true
  launch_configuration      = aws_launch_configuration.launch_config.id
  vpc_zone_identifier       = [aws_subnet.public_subnet1.id, aws_subnet.public_subnet2.id]
  target_group_arns         = [aws_lb_target_group.target_group.arn]
  tag {
    key                 = "name"
    value               = "ASG"
    propagate_at_launch = true
  }
}

#Create Auto-Scaling Policy
resource "aws_autoscaling_policy" "asg_policy" {
  autoscaling_group_name = aws_autoscaling_group.asg.name
  name = "asg_policy"
  adjustment_type = "ChangeInCapacity"
  policy_type = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 70.0
  }
}
