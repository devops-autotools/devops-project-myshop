locals {
  name_prefix = var.name_prefix != "" ? var.name_prefix : "${var.environment}.${var.project}"
  base_tags = {
    Environment = var.environment
    Project     = var.project
    ManagedBy   = "Terraform"
  }
  tags = merge(local.base_tags, var.tags)
}

# IAM Role SSM Access
resource "aws_iam_role" "ssm_role" {
    name = "${local.name_prefix}-ssm-role"
    assume_role_policy = data.aws_iam_policy_document.ssm_assume_role_policy.json
    tags = local.tags
}

# Data source for SSM Assume Role Policy
data "aws_iam_policy_document" "ssm_assume_role_policy" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

# IAM Policy for SSM
resource "aws_iam_role_policy_attachment" "ssm_role_attachment" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

# Instance Profile for the Role
resource "aws_iam_instance_profile" "ssm_instance_profile" {
  name = "${local.name_prefix}-ssm-instance-profile"
  role = aws_iam_role.ssm_role.name
  tags = local.tags
}
