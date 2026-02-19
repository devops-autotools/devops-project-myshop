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

# Security group rules
# Security Group rules
ingress_rules = [
  {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  },
  {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  },
  {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
]

egress_rules = [
  {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
]

# EC2 instance configuration
# EC2 Instance configuration
ami_id        = "ami-0ba8d27d35e9915fb"
instance_type = "t3.micro"
