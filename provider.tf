# Configure the AWS Provider
provider "aws" {
  region = "eu-west-1"
  profile = "default"
}

locals {
  name = "benny-pacpjpap-project"
}