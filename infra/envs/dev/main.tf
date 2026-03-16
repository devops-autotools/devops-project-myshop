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
  source      = "../../modules/role"
  environment = var.environment
  project     = var.project
  name_prefix = local.name_prefix
  tags        = local.tags
}

# Module for managing security groups in different environments
module "security_group" {
  source        = "../../modules/security_group"
  vpc_id        = module.vpc.vpc_id
  environment   = var.environment
  project       = var.project
  security_groups = var.security_groups
  tags          = local.tags
}

module "ec2" {
  source               = "../../modules/ec2"
  ami_id               = var.ami_id
  instance_type        = var.instance_type
  subnet_ids           = module.vpc.public_subnet_ids[0]
  security_group_ids   = [module.security_group.security_group_id["app"]]
  iam_instance_profile = module.role.instance_profile_name
  environment          = var.environment
  project              = var.project
  repo_url  = var.repo_url
  repo_name = var.repo_name
  default_user = var.default_user
  tags                 = local.tags
}

module "rds" {
  source = "../../modules/rds"

  environment = var.environment
  project     = var.project
  name_prefix = local.name_prefix
  tags        = local.tags

  db_name           = var.db_name
  username          = var.db_username
  password          = var.db_password # Nên dùng Secret Manager nếu làm dự án thật
  instance_class    = var.db_instance_class
  allocated_storage = var.db_storage

  # Lấy danh sách Subnet DB từ module VPC
  private_subnet_ids = module.vpc.db_private_subnet_ids
  
  # Lấy Security Group "db" đã được tạo từ module security_group
  vpc_security_group_ids = [module.security_group.security_group_id["db"]]
  app_security_group_id  = module.security_group.security_group_id["app"]
}