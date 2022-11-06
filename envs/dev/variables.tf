# AWS

variable "aws_region" {
  description = "AWS US Virginia Region"
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "AWS credentials profile"
  type        = string
  default     = "sandbox"
}

# Project

variable "env" {
  description = "Environment"
  type        = string
  default     = "dev"
}

variable "project_name" {
  type        = string
  description = "Project name"
  default     = "sbapp"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default = {
    Environment = "dev"
    Terraform   = "true"
  }
}

# Network

variable "vpc_cidr" {
  type        = string
  description = "The IP range to use for the VPC"
  default     = "10.0.0.0/16"
}

variable "subnet_group_num" {
  type        = number
  description = "Group of subnets: 10.(0).0.0/16"
  default     = 0
}

variable "public_subnet_nums" {
  type        = map(number)
  description = "Map of AZ to a number that should be used for public subnets: 10.0.(0).0/16"
  default = {
    "a" = 1
    "b" = 2
  }
}

variable "app_subnet_nums" {
  type        = map(number)
  description = "Map of AZ to a number that should be used for App private subnets 10.0.(0).0/16"
  default = {
    "a" = 3
    "b" = 4
  }
}

variable "db_subnet_nums" {
  type        = map(number)
  description = "Map of AZ to a number that should be used for database RDS private subnets 10.0.(0).0/16"
  default = {
    "a" = 5
    "b" = 6
  }
}

# Security

variable "db_port" {
  type        = number
  description = "DB port (MySQL)"
  default     = 3306
}

variable "app_port" {
  type        = number
  description = "App ECS container port"
  default     = 80
}

# Database

variable "db_secret_id" {
  type        = string
  description = "AWS Secret Manager DB secret ID"
  default     = "DatabaseSecret"
}

variable "db_name" {
  type        = string
  description = "Database name"
  default     = "sbappdb"
}

variable "db_family" {
  type        = string
  description = "Database engine family"
  default     = "mysql8.0"
}

variable "db_engine" {
  type        = string
  description = "Database engine type"
  default     = "mysql"
}

variable "db_engine_version" {
  type        = string
  description = "Database engine version"
  default     = "8.0.30"
}

variable "db_instance_class" {
  type        = string
  description = "Database instance type"
  default     = "db.t3.small"
}

variable "db_allocated_storage" {
  type        = number
  description = "Database allocated storage in gigabytes"
  default     = 100
}

variable "db_max_allocated_storage" {
  type        = number
  description = "Database maxium allocated storage in gigabytes to be increased when autoscaling capacity"
  default     = 1000
}

variable "db_multi_az" {
  type        = bool
  description = "Database multi or single AZ"
  default     = true
}

variable "db_backup_retention_period" {
  type        = number
  description = "Database backup retention period"
  default     = 14
}

variable "db_backup_window" {
  type        = string
  description = "Database backup window"
  default     = "01:00-03:00"
}

variable "db_maintenance_window" {
  type        = string
  description = "Database maintenance window"
  default     = "Mon:03:00-Mon:04:00"
}

# Containers & autoscaling

variable "ecs_ami_id" {
  type        = string
  description = "ECS AMI ID"
  default     = "ami-03201f9d49c2d89f4"
}

variable "ecs_instance_type" {
  type        = string
  description = "ECS instance type"
  default     = "t2.small"
}

variable "ecs_desired_count" {
  type        = number
  description = "ECS desired count"
  default     = 2
}

# # Notifications

# variable "sns_email_receiver" {
#   type        = string
#   description = "SNS email receiver"
#   default     = "<email-address>"
# }

# variable "sns_stack_name" {
#   type        = string
#   description = "SNS stack name"
#   default     = "<sns-stack-name>"
# }

# CI/CD Pipelines

variable "app_repository_name" {
  type        = string
  description = "Code Commit repository name"
  default     = "sbapp"
}

variable "app_repository_branch" {
  type        = string
  description = "Code Commit repository branch"
  default     = "main"
}

variable "build_timeout" {
  type        = string
  description = "The time to wait for a CodeBuild to complete before timing out in minutes (default: 5)"
  default     = "5"
}

variable "queued_timeout" {
  type        = string
  description = "Number of minutes, from 5 to 480 (8 hours), a build is allowed to be queued before it times out. The default is 8 hours."
  default     = "60"
}

variable "build_compute_type" {
  type        = string
  description = "The build instance type for CodeBuild (default: BUILD_GENERAL1_SMALL)"
  default     = "BUILD_GENERAL1_SMALL"
}

variable "build_image" {
  type        = string
  description = "The build image for CodeBuild to use (default: aws/codebuild/nodejs:6.3.1)"
  default     = "aws/codebuild/standard:5.0"
}

variable "package_buildspec" {
  type        = string
  description = "The buildspec to be used for the Package stage (default: buildspec.yml)"
  default     = "buildspec.yml"
}
