variable "aws_region" {
  type        = string
  description = "Infrastructure AWS region"
}

variable "env" {
  type        = string
  description = "Infrastructure environment"
}

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "vpc_cidr" {
  type        = string
  description = "The IP range to use for the VPC"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID created in module Network"
}

variable "db_port" {
  type        = number
  description = "DB port (MySQL)"
}

variable "app_port" {
  type        = number
  description = "APP ECS container port"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
}
