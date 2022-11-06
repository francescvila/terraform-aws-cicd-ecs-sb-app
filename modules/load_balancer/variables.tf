variable "env" {
  type        = string
  description = "Infrastructure environment"
}

variable "project_name" {
  type        = string
  description = "Project name"
}

variable "lb_security_groups" {
  type        = list(string)
  description = "Load Balancer Security Groups"
}

variable "lb_subnets" {
  type        = list(string)
  description = "Load Balancer Subnets"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID created in module Network"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
}
