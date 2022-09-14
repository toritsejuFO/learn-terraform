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
  profile                  = "hive_cli"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs             = [var.subnet_az]
  public_subnets  = [var.subnet_cidr]

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}

module "ssh_server_sg" {
  source = "terraform-aws-modules/security-group/aws//modules/ssh"

  name        = "ssh"
  description = "Security group for SSH ports open within VPC"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
}

module "key_pair" {
  source = "terraform-aws-modules/key-pair/aws"

  key_name   = "id_rsa"
  public_key = file(var.public_key)
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 4.0"

  name = "single-instance"

  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = "id_rsa"
  vpc_security_group_ids = [module.ssh_server_sg.security_group_id]
  subnet_id              = module.vpc.public_subnets[0]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
