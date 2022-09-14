output "ec2_public_ip" {
  value       = module.server.instance.public_ip
  description = "Public IP of EC2 instance"
}

output "ec2_ami_id" {
  value       = module.server.instance.ami
  description = "AMI ID of EC2 instance"
}