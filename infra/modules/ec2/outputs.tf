# Output for EC2 Instance ID
output "instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.app_server.id
}

# Output for EC2 Instance Public IP
output "public_ip" {
  description = "The public IP address of the EC2 instance"
  value       = aws_instance.app_server.public_ip
}

# Output for EC2 Instance Private IP
output "private_ip" {
  description = "The private IP address of the EC2 instance"
  value       = aws_instance.app_server.private_ip
}