# Variables for main.VPC environment
variable "environment" {
  description = "The environment for the deployment (e.g., dev, staging, prod)"
  type        = string
}
variable "project" {
  description = "The name of the project"
  type        = string
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
# --- IGNORE ---
