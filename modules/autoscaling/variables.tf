variable "aws_region" {
  type        = string
  description = "Infrastructure AWS region"
}

variable "env" {
  type        = string
  description = "Infrastructure environment"
}

variable "project_name" {
  type        = string
  description = "Project name"
}

variable "ecs_cluster_name" {
  type        = string
  description = "ECS cluster name"
}

variable "ecs_service_name" {
  type        = string
  description = "ECS service name"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID created in module Network"
}

variable "lb_security_groups" {
  type        = list(string)
  description = "Load Balancer security groups"
}

variable "lb_subnets" {
  type        = list(string)
  description = "Load Balancer security groups"
}
