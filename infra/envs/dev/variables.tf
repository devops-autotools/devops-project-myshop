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

variable "ingress_rules" {
  description = "Ingress rules for security group"
  type = list(object({
    from_port = number
    to_port   = number
    protocol  = string
    cidr_blocks      = list(string)
  }))
  default = []
}

variable "egress_rules" {
  description = "Egress rules for security group"
  type = list(object({
    from_port = number
    to_port   = number
    protocol  = string
    cidr_blocks      = list(string)
  }))
  default = []
}

variable "ami_id" {
  description = "The AMI ID for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "The type of EC2 instance to launch"
  type        = string
}