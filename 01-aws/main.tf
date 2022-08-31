terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "hive_cli"
}

data "aws_availability_zones" "azs" {}

resource "aws_vpc" "main" {
  cidr_block = var.main_vpc_cidr
  tags = {
    Name = "${var.main_vpc_name}"
  }
}

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_cidr
  availability_zone = var.public_subnet_zone
  # availability_zone = data.aws_availability_zones.azs.names[0]
  tags = {
    Name = "PublicSubnet"
  }
}
