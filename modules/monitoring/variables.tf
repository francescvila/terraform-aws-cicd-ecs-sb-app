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

variable "alarm_actions_high_cpu" {
  type        = list(string)
  description = "Alarm actions high CPU"
}

variable "alarm_actions_low_cpu" {
  type        = list(string)
  description = "Alarm actions low CPU"
}

variable "alarm_actions_high_5xx_errors" {
  type        = list(string)
  description = "Alarm actions high 5xx errors"
}

variable "autoscaling_group_name" {
  type        = string
  description = "Autoscaling group name"
}

variable "alb_arn_suffix" {
  type        = string
  description = "ALB ARN suffix"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
}
