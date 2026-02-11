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
