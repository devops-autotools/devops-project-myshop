locals {
  name_prefix = var.name_prefix != "" ? var.name_prefix : "${var.environment}.${var.project}"
  base_tags = {
    Environment = var.environment
    Project     = var.project
    ManagedBy   = "Terraform"
  }
  tags = merge(local.base_tags, var.tags)
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "${local.name_prefix}-db-subnet-group"
  subnet_ids = var.private_subnet_ids
  tags       = local.tags
}
