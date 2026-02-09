# Module for managing VPC resources in different environments
module "vpc" {
  source = "../../modules/vpc"

  cidr_block  = var.vpc_cidr_block
  azs         = var.availability_zones
  environment = var.environment
  project     = var.project
  name_prefix = local.name_prefix
  tags        = local.tags
}
