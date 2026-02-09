# Terraform variables for main environment
environment = "dev"
project     = "my.shop.project"
region      = "ap-southeast-2"

# VPC Configuration

vpc_cidr_block     = "192.0.0.0/16"
availability_zones = ["ap-southeast-2a", "ap-southeast-2b", "ap-southeast-2c"]

tags = {
  Owner = "thalt"
}
