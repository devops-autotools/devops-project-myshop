# EC2 Instance Variables

variable "name_prefix" {
  description = "Optional name prefix for resource Name tags"
  type        = string
  default     = ""
}

# Variable for the environment (e.g., dev, staging, prod)
variable "environment" {
  description = "The environment for the deployment (e.g., dev, staging, prod)"
  type        = string
}

# Variable for the project name
variable "project" {
  description = "The name of the project"
  type        = string
}

variable "ami_id" {
  description = "The AMI ID to use for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "The type of EC2 instance to launch"
  type        = string
}

variable "subnet_ids" {
  description = "The subnet IDs in which to launch the EC2 instance"
  type        = string
}

variable "security_group_ids" {
  description = "List of security group IDs to associate with the EC2 instance"
  type        = list(string)
}

variable "iam_instance_profile" {
  description = "IAM instance profile to associate with the EC2 instance"
  type        = string
}

# Tags variable
variable "tags" {
  description = "A map of tags to assign to resources"
  type        = map(string)
  default     = {}
}