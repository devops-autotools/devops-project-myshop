locals {
  name_prefix = var.name_prefix != "" ? var.name_prefix : "${var.environment}.${var.project}"
  tags = merge(
    {
      Environment = var.environment
      Project     = var.project
      ManagedBy   = "Terraform"
    },
    var.tags
  )
}
