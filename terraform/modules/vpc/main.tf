# VPC resource
resource "aws_vpc" "this" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = merge(
    {
      Name = "vpc.${var.environment}.${var.project}"
    },
    var.tags
  )
}

# Create Public Subnets
resource "aws_subnet" "public" {
  count                   = min(3, length(var.azs))
  vpc_id                  = aws_vpc.this.id
  cidr_block              = cidrsubnet(var.cidr_block, 8, count.index)
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = true
  tags = merge(
    {
      Name = "${var.environment}.${var.project}.public.subnet-${count.index + 1}"
    },
    var.tags
  )
}

# Create Application Private Subnets
resource "aws_subnet" "app_private" {
  count                   = min(3, length(var.azs))
  vpc_id                  = aws_vpc.this.id
  cidr_block              = cidrsubnet(var.cidr_block, 8, count.index + 10)
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = false
  tags = merge(
    {
      Name = "${var.environment}.${var.project}.app.private.subnet-${count.index + 1}"
    },
    var.tags
  )
}

# Create Database Private Subnets
resource "aws_subnet" "db_private" {
  count             = min(3, length(var.azs))
  vpc_id            = aws_vpc.this.id
  cidr_block        = cidrsubnet(var.cidr_block, 8, count.index + 20)
  availability_zone = var.azs[count.index]
  tags = merge(
    {
      Name = "${var.environment}.${var.project}.db.private.subnet-${count.index + 1}"
    },
    var.tags
  )
}

# Internet Gateway
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags = merge(
    {
      Name = "${var.environment}.${var.project}.igw"
    },
    var.tags
  )
}

# Elatic IP for NAT Gateway
resource "aws_eip" "nat" {
  tags = merge(
    {
      Name = "${var.environment}.${var.project}.nat.eip"
    },
    var.tags
  )
}

# NAT Gateway
resource "aws_nat_gateway" "this" {
  allocation_id     = aws_eip.nat.id
  availability_mode = "zonal"
  connectivity_type = "public"
  subnet_id         = aws_subnet.public[0].id
  tags = merge(
    {
      Name = "${var.environment}.${var.project}.nat.gateway"
    },
    var.tags
  )
}

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.this.id
    }
  tags = merge(
    {
      Name = "${var.environment}.${var.project}.public.rt"
    },
    var.tags
  )
}

# Private Route Table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id
  route {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.this.id
    }
  tags = merge(
    {
      Name = "${var.environment}.${var.project}.private.rt"
    },
    var.tags
  )
}

# Associate Public Subnets with Public Route Table
resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Associate Application Private Subnets with Private Route Table
resource "aws_route_table_association" "app_private" {
  count          = length(aws_subnet.app_private)
  subnet_id      = aws_subnet.app_private[count.index].id
  route_table_id = aws_route_table.private.id
}

# Associate Database Private Subnets with Private Route Table
resource "aws_route_table_association" "db_private" {
  count          = length(aws_subnet.db_private)
  subnet_id      = aws_subnet.db_private[count.index].id
  route_table_id = aws_route_table.private.id
}