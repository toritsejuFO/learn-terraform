terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

resource "aws_instance" "server" {
  ami = var.ami_id
  instance_type = var.instance_type
  count = var.server_count
}
