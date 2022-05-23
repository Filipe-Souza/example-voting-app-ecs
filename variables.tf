variable "project_name" {
  default = "votingapp"
  description = "The global project name to identify resources. Try using no special characters and short names"
  type = string
}

variable "database_username" {
  default = "postgres"
  description = "Username for the PostgreSQL database"
  type = string
}

variable "security_group_description" {
  default = "Allows traffic from internet"
  description = "Allows all traffic from the internet to the resources"
  type = string
}

variable "db_security_group_description" {
  default = "Allows traffic from the application security group"
  description = "Allows all traffic from the apps SG to the resouces."
  type = string
}

variable "region" {
  default = "us-east-1"
  description = "AWS region for building resources"
  type = string
}
