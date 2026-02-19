# Variable for the name of the role
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

# Variable for additional tags
variable "tags" {
  description = "A map of tags to assign to resources"
  type        = map(string)
  default     = {}
}

# Variable for the VPC ID
variable "vpc_id" {
  description = "The ID of the VPC where the security group will be created"
  type        = string
}

# Variable for ingress rules
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