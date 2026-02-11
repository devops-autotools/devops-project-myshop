# Output for the role name
output "role_name" {
  description = "The name of the created IAM role"
  value       = aws_iam_role.ssm_role.name
}

# Output for the instance profile name
output "instance_profile_name" {
  description = "The name of the created IAM instance profile"
  value       = aws_iam_instance_profile.ssm_instance_profile.name
}

# Output for the role ARN
output "role_arn" {
  description = "The ARN of the created IAM role"
  value       = aws_iam_role.ssm_role.arn
}

# Output for the instance profile ARN
output "instance_profile_arn" {
  description = "The ARN of the created IAM instance profile"
  value       = aws_iam_instance_profile.ssm_instance_profile.arn
}