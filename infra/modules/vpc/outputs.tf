# Outputs for VPC module
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.this.id
}
output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.this.cidr_block
}
output "availability_zones" {
  description = "Availability zones used for the subnets"
  value       = var.azs
}
output "public_subnet_ids" {
  description = "List of IDs of the public subnets"
  value       = aws_subnet.public[*].id
}
output "public_subnet_cidr_blocks" {
  description = "List of CIDR blocks of the public subnets"
  value       = aws_subnet.public[*].cidr_block
}
output "app_private_subnet_ids" {
  description = "List of IDs of the application private subnets"
  value       = aws_subnet.app_private[*].id
}
output "app_private_subnet_cidr_blocks" {
  description = "List of CIDR blocks of the application private subnets"
  value       = aws_subnet.app_private[*].cidr_block
}
output "db_private_subnet_ids" {
  description = "List of IDs of the database private subnets"
  value       = aws_subnet.db_private[*].id
}
output "db_private_subnet_cidr_blocks" {
  description = "List of CIDR blocks of the database private subnets"
  value       = aws_subnet.db_private[*].cidr_block
}
output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = aws_internet_gateway.this.id
}
output "nat_gateway_id" {
  description = "The ID of the NAT Gateway"
  value       = aws_nat_gateway.this.id
}
output "nat_eip_allocation_id" {
  description = "The allocation ID of the NAT Gateway Elastic IP"
  value       = aws_eip.nat.id
}
output "nat_eip_public_ip" {
  description = "The public IP address of the NAT Gateway Elastic IP"
  value       = aws_eip.nat.public_ip
}
output "public_route_table_id" {
  description = "The ID of the public route table"
  value       = aws_route_table.public.id
}
output "private_route_table_id" {
  description = "The ID of the private route table"
  value       = aws_route_table.private.id
}
