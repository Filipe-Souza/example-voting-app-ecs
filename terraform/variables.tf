variable "project_name" {
  default     = "votingapp"
  description = "The global project name to identify resources. Try using no special characters and short names"
  type        = string
}

variable "database_username" {
  default     = "postgres"
  description = "Username for the PostgreSQL database"
  type        = string
}

variable "security_group_description" {
  default     = "Allows traffic from internet"
  description = "Allows all traffic from the internet to the resources"
  type        = string
}

variable "db_security_group_description" {
  default     = "Allows traffic from the application security group"
  description = "Allows all traffic from the apps SG to the resouces."
  type        = string
}

variable "region" {
  default     = "us-east-1"
  description = "AWS region for building resources"
  type        = string
}

variable "alarm_actions" {
  type        = list(string)
  description = "Supply the list of AWS SNS topics ARNs here for the cloudwatch metrics for the ALARM conditions"
  default     = []
}
variable "ok_actions" {
  type        = list(string)
  description = "Supply the list of AWS SNS topics ARNs here for the cloudwatch metrics for the OK conditions"
  default     = []
}

variable "p95_latency_seconds_threshold" {
  type        = number
  description = "Numer of seconds to evaluate the 95% of the requests response times."
  default     = 1.5
}
variable "target_5xx_threshold" {
  type        = number
  description = "The number of 5xx errors in 5 minutes to consider the application is unhealth."
  default     = 5
}
variable "healthy_hosts_min" {
  type        = number
  description = "The minimum number of instances in the TG to consider it low."
  default     = 1
}
variable "request_count_min" {
  type        = number
  description = "The minimum number of requests in 5 minutes to consider the application has no traffic."
  default     = 1
}
