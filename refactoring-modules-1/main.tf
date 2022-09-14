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

module "network" {
  source = "../modules/network"
}

module "server" {
  source        = "../modules/server"
  vpc_id        = module.network.main_vpc_id
  subnet_id     = module.network.public_subnet_id
  public_key    = var.public_key
  instance_type = var.instance_type
  script_name   = var.script_name
}
