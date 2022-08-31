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
  profile                 = "hive_cli"
}

resource "aws_instance" "server" {
  ami           = "ami-05fa00d4c63e32376"
  instance_type = "t2.micro"
}
