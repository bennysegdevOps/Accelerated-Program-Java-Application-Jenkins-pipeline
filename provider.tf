# Configure the AWS Provider
provider "aws" {
  region = var.region
}

locals {
  name = "benny-pacpjpap-project"
}