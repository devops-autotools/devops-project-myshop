# Outputs for the VPC module in the development environment

output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.vpc.vpc_cidr_block
}

output "availability_zones" {
  description = "Availability zones used for the subnets"
  value       = module.vpc.availability_zones
}

output "public_subnet_ids" {
  description = "List of IDs of the public subnets"
  value       = module.vpc.public_subnet_ids
}

output "public_subnet_cidr_blocks" {
  description = "List of CIDR blocks of the public subnets"
  value       = module.vpc.public_subnet_cidr_blocks
}

output "app_private_subnet_ids" {
  description = "List of IDs of the application private subnets"
  value       = module.vpc.app_private_subnet_ids
}

output "app_private_subnet_cidr_blocks" {
  description = "List of CIDR blocks of the application private subnets"
  value       = module.vpc.app_private_subnet_cidr_blocks
}

output "db_private_subnet_ids" {
  description = "List of IDs of the database private subnets"
  value       = module.vpc.db_private_subnet_ids
}

output "db_private_subnet_cidr_blocks" {
  description = "List of CIDR blocks of the database private subnets"
  value       = module.vpc.db_private_subnet_cidr_blocks
}

output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = module.vpc.internet_gateway_id
}

output "nat_gateway_id" {
  description = "The ID of the NAT Gateway"
  value       = module.vpc.nat_gateway_id
}

output "nat_eip_allocation_id" {
  description = "The allocation ID of the NAT Gateway Elastic IP"
  value       = module.vpc.nat_eip_allocation_id
}

output "nat_eip_public_ip" {
  description = "The public IP address of the NAT Gateway Elastic IP"
  value       = module.vpc.nat_eip_public_ip
}

output "public_route_table_id" {
  description = "The ID of the public route table"
  value       = module.vpc.public_route_table_id
}

output "private_route_table_id" {
  description = "The ID of the private route table"
  value       = module.vpc.private_route_table_id
}

# Output Role ARN for SSM Access
# output "ssm_role_arn" {
#   description = "The ARN of the IAM Role for SSM Access"
#   value       = module.role.ssm_role_arn
# }

output "ssm_instance_profile_name" {
  description = "The name of the IAM Instance Profile for SSM Access"
  value       = module.role.instance_profile_name
}

# Output for Security Group ID
output "app_security_group_id" {
  description = "The ID of the application security group"
  value       = module.security_group.security_group_id
}

# Output for Security Group ARN
output "app_security_group_arn" {
  description = "The ARN of the application security group"
  value       = module.security_group.security_group_arn
}

# Output for EC2 Instance ID
output "ec2_instance_id" {
  description = "The ID of the EC2 instance"
  value       = module.ec2.instance_id
} 

# Output for EC2 Instance Public IP
output "ec2_public_ip" {
  description = "The public IP address of the EC2 instance"
  value       = module.ec2.public_ip
}