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

resource "aws_vpc" "main_vpc" {
  cidr_block = var.main_vpc_cidr
  tags = {
    Name = "${var.main_vpc_name}"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.public_subnet_cidr
  # availability_zone = var.public_subnet_zone # example of TF_VAR_... env var
  availability_zone = data.aws_availability_zones.azs.names[0]
  tags = {
    Name = "PublicSubnet"
  }
}

resource "aws_internet_gateway" "main_vpc_igw" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "${var.main_vpc_name} IGW"
  }
}

resource "aws_default_route_table" "main_vpc_default_rt" {
  default_route_table_id = aws_vpc.main_vpc.default_route_table_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_vpc_igw.id
  }
  tags = {
    Name = "My default RT"
  }
}

resource "aws_default_security_group" "default_sg" {
  vpc_id = aws_vpc.main_vpc.id
  ingress {
    to_port = 22
    from_port = 22
    cidr_blocks = [var.all_addresses]
    # cidr_blocks = [var.my_public_ip]
    protocol = "tcp"
  }
  ingress {
    to_port = 80
    from_port = 80
    cidr_blocks = [var.all_addresses]
    protocol = "tcp"
  }
  egress {
    to_port = 0
    from_port = 0
    cidr_blocks = [var.all_addresses]
    protocol = -1
  }
  tags = {
    Name = "Default SG"
  }
}
