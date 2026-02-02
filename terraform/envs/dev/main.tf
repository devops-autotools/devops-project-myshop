# Terraform configuration for main environment
locals {
  common_tags = {
    Environment = var.environment
    Project     = var.project
    ManagedBy   = "Terraform"
  }
}

# Module for managing VPC resources in different environments
module "vpc" {
  source = "../../modules/vpc"

  cidr_block  = var.vpc_cidr_block
  azs         = var.availability_zones
  environment = local.common_tags.Environment
  project     = local.common_tags.Project
  tags        = local.common_tags
}