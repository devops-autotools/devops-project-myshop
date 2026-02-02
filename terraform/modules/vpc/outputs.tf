# Outputs for VPC module
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.this.id
}
output "public_subnet_ids" {
  description = "List of IDs of the public subnets"
  value       = aws_subnet.public[*].id
}
output "app_private_subnet_ids" {
  description = "List of IDs of the application private subnets"
  value       = aws_subnet.app_private[*].id
}
output "db_private_subnet_ids" {
  description = "List of IDs of the database private subnets"
  value       = aws_subnet.db_private[*].id
}
output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = aws_internet_gateway.this.id
}
output "nat_eip_allocation_id" {
  description = "The allocation ID of the NAT Gateway Elastic IP"
  value       = aws_eip.nat.id
}
output "nat_eip_public_ip" {
  description = "The public IP address of the NAT Gateway Elastic IP"
  value       = aws_eip.nat.public_ip
}
