locals {
  name_prefix = var.name_prefix != "" ? var.name_prefix : "${var.environment}.${var.project}"
  base_tags = {
    Environment = var.environment
    Project     = var.project
    ManagedBy   = "Terraform"
  }
  tags = merge(local.base_tags, var.tags)
}

resource "aws_security_group" "sg" {
  for_each = var.security_groups

  name        = "${local.name_prefix}-${each.key}"
  description = each.value.description
  vpc_id      = var.vpc_id
  tags        = local.tags

  dynamic "ingress" {
    for_each = each.value.ingress_rules
    content {
      from_port = ingress.value.from_port
      to_port   = ingress.value.to_port
      protocol  = ingress.value.protocol

      cidr_blocks      = lookup(ingress.value, "cidr_blocks", null)
      security_groups  = lookup(ingress.value, "sg_ids", null)
    }
  }

  dynamic "egress" {
    for_each = each.value.egress_rules
    content {
      from_port = egress.value.from_port
      to_port   = egress.value.to_port
      protocol  = egress.value.protocol

      cidr_blocks      = lookup(egress.value, "cidr_blocks", null)
      security_groups  = lookup(egress.value, "sg_ids", null)
    }
  }
}