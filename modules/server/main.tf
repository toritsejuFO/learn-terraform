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

resource "aws_default_security_group" "default_sg" {
  vpc_id = var.vpc_id
  ingress {
    to_port     = 22
    from_port   = 22
    cidr_blocks = [var.all_addresses]
    protocol    = "tcp"
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
  public_key = file(var.public_key)
}

resource "aws_instance" "ec2_instance" {
  ami                         = data.aws_ami.latest_amazon_linux2.id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [aws_default_security_group.default_sg.id]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.ec2_key_pair.key_name
  user_data                   = file(var.script_name)

  tags = {
    Name        = "EC2 Instance"
    Environment = local.Environment
  }
}
