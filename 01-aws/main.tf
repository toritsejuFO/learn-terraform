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

data "aws_ami" "latest_amazon_linux2" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-*-x86_64-gp2"]
  }
}

resource "aws_vpc" "main_vpc" {
  cidr_block = var.main_vpc_cidr
  tags = {
    Name = "${var.main_vpc_name}"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = var.public_subnet_cidr
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
    to_port     = 22
    from_port   = 22
    cidr_blocks = [var.all_addresses]
    # cidr_blocks = [var.my_public_ip]
    protocol = "tcp"
  }
  ingress {
    to_port     = 80
    from_port   = 80
    cidr_blocks = [var.all_addresses]
    protocol    = "tcp"
  }
  ingress {
    to_port     = 8080
    from_port   = 8080
    cidr_blocks = [var.all_addresses]
    protocol    = "tcp"
  }
  egress {
    to_port     = 0
    from_port   = 0
    cidr_blocks = [var.all_addresses]
    protocol    = -1
  }
  tags = {
    Name = "Default SG"
  }
}

resource "aws_key_pair" "ec2_key_pair" {
  key_name   = "id_rsa"
  public_key = file("~/.ssh/ec2_kp.pub")
}

resource "aws_instance" "ec2_instance" {
  # ami = "ami-05fa00d4c63e32376"
  ami                         = data.aws_ami.latest_amazon_linux2.id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public_subnet.id
  vpc_security_group_ids      = [aws_default_security_group.default_sg.id]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.ec2_key_pair.key_name
  # user_data                   = file("entry-script.sh") # Configure infrastructure: user-data example
  # user_data                   = templatefile("../web-app-template.yaml", {}) # Configure infrastructure: template file example

  # Configure infrastructure: provisoiner example
  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = file("~/.ssh/ec2_kp")
  }

  provisioner "file" {
    source      = "./entry-script.sh"
    destination = "/home/ec2-user/entry-script.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod u+x ~/entry-script.sh",
      "sudo ~/entry-script.sh",
      "exit"
    ]
    on_failure = continue
  }

  tags = {
    Name = "EC2 Instance"
    Environment = local.Environment
  }
}
