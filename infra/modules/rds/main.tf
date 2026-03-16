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

resource "aws_security_group_rule" "allow_app_access" {
  # Chỉ tạo rule này nếu có truyền app_security_group_id
  count = var.app_security_group_id != "" ? 1 : 0

  type                     = "ingress"
  from_port                = var.port
  to_port                  = var.port
  protocol                 = "tcp"
  
  # ID của SG của chính Database (lấy cái đầu tiên trong list)
  security_group_id        = var.vpc_security_group_ids[0]
  
  # ID của SG phía App được phép đi vào
  source_security_group_id = var.app_security_group_id
}

resource "aws_db_instance" "postgres" {
  identifier           = replace(lower("${local.name_prefix}-rds"), ".", "-")
  engine               = "postgres"
  engine_version       = var.engine_version
  instance_class       = var.instance_class
  allocated_storage    = var.allocated_storage
  
  db_name              = var.db_name
  username             = var.username
  password             = var.password
  port                 = var.port

  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = var.vpc_security_group_ids
  
  multi_az               = var.multi_az
  publicly_accessible    = var.publicly_accessible
  skip_final_snapshot    = var.skip_final_snapshot

  tags = local.tags
}