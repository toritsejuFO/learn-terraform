# VPC
variable "main_vpc_cidr" {
  default = "10.0.0.0/16"
  description = "VPC CIDR block"
  type = string
}

variable main_vpc_name {}

# Subnet
variable "public_subnet_cidr" {
  default = "10.0.0.0/24"
  description = "Public Subnet CIDR block"
  type = string
}

variable "public_subnet_zone" {}
