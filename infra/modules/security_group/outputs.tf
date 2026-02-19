# Output for Security Group ID
output "security_group_id" {
  description = "The ID of the application security group"
  value       = aws_security_group.app_sg.id
}

# Output for Security Group ARN
output "security_group_arn" {
  description = "The ARN of the application security group"
  value       = aws_security_group.app_sg.arn
}
