# vpc cidr block
variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

# public subnet 1 cidr block
variable "pub_sub1_cidr" {
  default = "10.0.1.0/24"
}

# availability zone 1
variable "availability_zone_1" {
  default = "eu-west-1a"
}

# public subnet 2 cidr block
variable "pub_sub2_cidr" {
  default = "10.0.2.0/24"
}

# availability zone 2
variable "availability_zone_2" {
  default = "eu-west-1b"
}

# private subnet 1 cidr block
variable "priv_sub1_cidr" {
  default = "10.0.3.0/24"
}

# private subnet 2 cidr block
variable "priv_sub2_cidr" {
  default = "10.0.4.0/24"
}

# all traffic cidr
variable "RT_cidr" {
  default = "0.0.0.0/0"
}

# ssh port access
variable "port_ssh" {
  default = "22"
}

# proxy port for Jenkins and Docker 
variable "port_proxy" {
  default = "8080"
}

# http port access
variable "port_http" {
  default = "80"
}

# https port access
variable "port_https" {
  default = "443"
}

# sonarqube port access
variable "port_sonar" {
  default = "9000"
}

# nexus port access
variable "port_proxy_nex" {
  default = "8081"
}

# Mysql port access
variable "port_mysql" {
  default = "3306"
}

# ubuntu ami
variable "ami" {
  default = "ami-01dd271720c1ba44f"  
}

# red hat ami
variable "ami2" {
  default = "ami-013d87f7217614e10"
}

# instance type
variable "instance_type" {
  default = "t2.micro"
}

# instance type
variable "instance_type2" {
  default = "t2.medium"
}

# key name
variable "key_name" {
  default = "benny-keypair"
}

# public keypair path
variable "keypair_path" {
  default = "~/Desktop/keypair/benny.pub"
}

# private keypair path
variable "private_keypair_path" {
  default = "~/Desktop/keypair/benny"
}

# new relic license key
variable "nr_license_key" {
  default = "c605530d3bdfc50e00542ec7f199be7efebaNRAL"
}

# new relic file path
variable "newrelicfile" {
  default = "/newrelic.yml"
}

# db identifier
variable "db_identifier" {
  default = "petadopt-db"
}

# db name
variable "db_name" {
  default = "petadopt-db"
}

# db engine
variable "db_engine" {
  default = "mysql"
}

# db engine version
variable "db_engine_version" {
  default = "5.7"
}

# db instance class
variable "db_instance_class" {
  default = "db.t3.micro"
}

# db username
variable "db_username" {
  default = "admin"
}

# db password
variable "db_password" {
  default = "Admin123@"
}

# db parameter group name
variable "db_parameter_gp_name" {
  default = "default.mysql5.7"
}

# db storage type
variable "db_storage_type" {
  default = "gp2"
}

# domain name
variable "domain_name" {
  default = "wehabot.com"
}
