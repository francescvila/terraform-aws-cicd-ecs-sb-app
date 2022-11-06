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

variable "sns_email_addresses" {
  type        = list(string)
  description = "Email address to send notifications to"
}

variable "sns_protocol" {
  default     = "email"
  description = "SNS Protocol to use. email or email-json"
  type        = string
}

variable "sns_stack_name" {
  type        = string
  description = "Unique Cloudformation stack name that wraps the SNS topic."
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
}
