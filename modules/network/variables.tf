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

variable "subnet_group_num" {
  type        = number
  description = "Group of subnets: 10.(0).0.0/16"
}

variable "public_subnet_nums" {
  type        = map(number)
  description = "Map of AZ to a number that should be used for public subnets"
}

variable "app_subnet_nums" {
  type        = map(number)
  description = "Map of AZ to a number that should be used for App private subnets 10.0.(0).0/16"
}

variable "db_subnet_nums" {
  type        = map(number)
  description = "Map of AZ to a number that should be used for database RDS private subnets 10.0.(0).0/16"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
}
