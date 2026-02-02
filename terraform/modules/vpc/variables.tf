variable "environment" {
  type        = string
  description = "The environment for the deployment (e.g., dev, staging, prod)"
}

variable "project" {
  type        = string
  description = "The name of the project"
}

variable "cidr_block" {
  type        = string
  description = "The CIDR block for the VPC"
}

variable "azs" {
  type        = list(string)
  description = "A list of availability zones in which to create subnets"
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to assign to resources"
  default     = {}
}


