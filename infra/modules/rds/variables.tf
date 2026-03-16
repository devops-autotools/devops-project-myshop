variable "environment" { 
    type = string
    description = "The environment for the deployment (e.g., dev, staging, prod)" 
}

variable "project"     { 
    type = string 
    description = "The name of the project"
}
variable "name_prefix" { 
    type = string 
    default = "" 
    description = "Optional name prefix for resource Name tags"
}

variable "tags" { 
    type = map(string)
    default = {} 
    description = "A map of tags to assign to resources"
}

variable "db_name"  { 
    type = string 
    description = "The name of the RDS database" 
}

variable "engine_version"  { 
    type = string
    default = "15" 
    description = "The version of the database engine (e.g., 15 for PostgreSQL 15)" 
}

variable "instance_class"  { 
    type = string
    default = "db.t3.micro" 
    description = "The instance class for the RDS instance (e.g., db.t3.micro)"
}

variable "allocated_storage" { 
    type = number 
    default = 20 
    description = "The allocated storage size in GB for the RDS instance"
}

variable "username"  { 
    type = string
    description = "The username for the RDS database"
}

variable "password" { 
    type = string 
    sensitive = true 
    description = "The password for the RDS database"
}

variable "port" { 
    type = number 
    default = 5432 
    description = "The port on which the database will listen (default is 5432 for PostgreSQL)"
}

variable "private_subnet_ids"  { 
    type = list(string) 
    description = "A list of subnet IDs for the RDS instance"
}

variable "vpc_security_group_ids" { 
    type = list(string) 
    description = "A list of VPC security group IDs to associate with the RDS instance"
}

variable "multi_az"  { 
    type = bool 
    default = false 
    description = "Whether to create a Multi-AZ RDS instance for high availability"
}

variable "publicly_accessible" { 
    type = bool 
    default = false 
    description = "Whether the RDS instance should be publicly accessible"
}

variable "skip_final_snapshot" { 
    type = bool 
    default = true 
    description = "Whether to skip the final snapshot when deleting the RDS instance"
}

variable "app_security_group_id" {
    type = string 
    default = "" 
    description = "The ID of the application security group that should be allowed to access the RDS instance (optional)"
}