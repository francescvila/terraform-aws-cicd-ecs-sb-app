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

variable "target_domain_name" {
  type        = string
  description = "Target domain name"
}

variable "origin_id" {
  type        = string
  description = "Target origin ID"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
}
