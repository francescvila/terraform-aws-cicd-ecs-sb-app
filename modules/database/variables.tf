variable "aws_region" {
  type        = string
  description = "Infrastructure AWS region"
}

variable "aws_profile" {
  type        = string
  description = "AWS credentials profile"
}

variable "env" {
  type        = string
  description = "Infrastructure environment"
}

variable "project_name" {
  type        = string
  description = "Project name"
}

variable "db_username" {
  type        = string
  description = "Database username"
}

variable "db_password" {
  type        = string
  description = "Database password"
}

variable "db_name" {
  type = string
  description = "Database name"
}

variable "db_port" {
  type        = number
  description = "Database name"
}

variable "db_subnets" {
  type        = list(string)
  description = "Database private subnets"
}

variable "db_security_groups" {
  type        = list(string)
  description = "Database security groups"
}

variable "db_family" {
  type        = string
  description = "Database engine family"
}

variable "db_allocated_storage" {
  type        = number
  description = "Database allocated storage in gigabytes"
}

variable "db_max_allocated_storage" {
  type        = number
  description = "Database maxium allocated storage in gigabytes to be increased when autoscaling capacity"
}

variable "db_engine" {
  type        = string
  description = "Database engine type"
}

variable "db_engine_version" {
  type        = string
  description = "Database engine version"
}

variable "db_instance_class" {
  type        = string
  description = "Database instance type"
}

variable "db_multi_az" {
  type        = bool
  description = "Database multi or single AZ"
}

variable "db_backup_retention_period" {
  type        = number
  description = "Database backup retention period"
}

variable "db_backup_window" {
  type        = string
  description = "Database backup window"
}

variable "db_maintenance_window" {
  type        = string
  description = "Database maintenance window"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
}
