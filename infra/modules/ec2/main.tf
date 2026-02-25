locals {
  name_prefix = var.name_prefix != "" ? var.name_prefix : "${var.environment}.${var.project}"
  base_tags = {
    Environment = var.environment
    Project     = var.project
    ManagedBy   = "Terraform"
  }
  tags = merge(local.base_tags, var.tags)
}

resource "aws_instance" "app_server" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_ids
  vpc_security_group_ids = var.security_group_ids
  iam_instance_profile   = var.iam_instance_profile
  user_data = templatefile(
    "${path.module}/scripts/user-data.sh.tpl",
    {
      repo_url  = var.repo_url
      repo_name = var.repo_name
      default_user = var.default_user
    }
  )

  tags                   = local.tags
}