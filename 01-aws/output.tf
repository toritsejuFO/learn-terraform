output "main_vpc_id" {
  value = aws_vpc.main_vpc.id
  description = "IP of Main VPC"
}

output "ec2_public_ip" {
  value = aws_instance.ec2_instance.public_ip
  description = "Public IP of EC2 instance"
}

output "ec2_ami_id" {
  value = aws_instance.ec2_instance.ami
  description = "AMI ID of EC2 instance"
  sensitive = true
}