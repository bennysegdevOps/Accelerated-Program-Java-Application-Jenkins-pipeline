# aws region
variable "region" {
  default = "eu-west-1"
}

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
  default = "ami-00aa9d3df94c6c354"
}

# red hat ami
variable "ami2" {
  default = "ami-0b04ce5d876a9ba29"
}

# instance type
variable "instance_type" {
  default = "t2.micro"
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