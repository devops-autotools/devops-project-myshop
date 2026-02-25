# Output for the security group ID
output "security_group_id" {
  description = "A map of security group IDs created by this module"
  value       = { for sg_name, sg in aws_security_group.sg : sg_name => sg.id }
}

# Output for the security group ARN
output "security_group_arn" {
  description = "A map of security group ARNs created by this module"
  value       = { for sg_name, sg in aws_security_group.sg : sg_name => sg.arn }
}
