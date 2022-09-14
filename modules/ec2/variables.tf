variable "ami_id" {
  description = "AMI ID to provision"
  type = string
  default = "ami-05fa00d4c63e32376"
}

variable "instance_type" {
  description = "Instance type"
  type = string
  default = "t2.micro"
}

variable "server_count" {
  description = "Number of instances to create"
  type = number
  default = 1
}
