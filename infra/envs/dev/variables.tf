# Variables for dev environment
variable "environment" {
  description = "The environment for the deployment (e.g., dev, staging, prod)"
  type        = string
}
variable "project" {
  description = "The name of the project"
  type        = string
}
variable "region" {
  description = "AWS region for the environment"
  type        = string
}
variable "name_prefix" {
  description = "Optional name prefix for resource Name tags"
  type        = string
  default     = ""
}
variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "availability_zones" {
  description = "A list of availability zones in which to create subnets"
  type        = list(string)
}

variable "tags" {
  description = "A map of tags to assign to resources"
  type        = map(string)
  default     = {}
}

variable "security_groups" {
  description = "A map of security group configurations"
  type = any
}


variable "ami_id" {
  description = "The AMI ID for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "The type of EC2 instance to launch"
  type        = string
}

variable "repo_url" {
  type        = string
  description = "Git repository URL"
}

variable "repo_name" {
  type        = string
  description = "Repository folder name"
}

variable "default_user" {
  type        = string
  description = "Default user to create on the EC2 instance"
}

# RDS variables
variable "db_name" { 
  description = "The name of the database"
  type = string 
}

variable "db_username" { 
  description = "The username for the database"
  type = string 
}

variable "db_password" { 
  description = "The password for the database"
  type = string 
  sensitive = true 
}

variable "db_instance_class" { 
  description = "The instance class for the RDS instance"
  type = string 
  default = "db.t3.micro" 
}
variable "db_storage" { 
  description = "The allocated storage for the RDS instance in GB"
  type = number 
  default = 20 
}