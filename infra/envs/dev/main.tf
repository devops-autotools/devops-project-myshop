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

# Module for managing IAM roles in different environments
module "role" {
  source = "../../modules/role"
  environment = var.environment
  project     = var.project
  name_prefix = local.name_prefix
  tags        = local.tags
}

# Module for managing security groups in different environments
module "security_group" {
  source        = "../../modules/security_group"
  vpc_id        = module.vpc.vpc_id
  environment = var.environment
  project     = var.project
  ingress_rules = var.ingress_rules
  egress_rules  = var.egress_rules
  tags          = local.tags
}

module "ec2" {
  source        = "../../modules/ec2"
  ami_id               = var.ami_id
  instance_type        = var.instance_type
  subnet_ids     = module.vpc.public_subnet_ids[0]
  security_group_ids = [module.security_group.security_group_id]
  iam_instance_profile = module.role.instance_profile_name
  environment   = var.environment
  project       = var.project
  tags          = local.tags
}