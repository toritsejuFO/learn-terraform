terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  shared_credentials_files = ["~/.aws/credentials"]
  profile = "hive_cli"
}

module "ec2" {
  source = "../modules/ec2"
  ami_id = var.ami_id
  instance_type = var.instance_type
  server_count = var.server_count
}
