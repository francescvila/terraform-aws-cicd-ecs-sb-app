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

variable "container_port" {
  type = string
  description = "App ECS container port"
}

# variable "ecs_service_iam_role" {
#   type = string
#   description = "ECS IAM role"
# }

# variable "ecs_service_iam_policy_attachment" {
#   type = any
#   description = "ECS IAM policy attachment"
# }

variable "target_group_arn" {
  type        = string
  description = "Target group ARN"
}

# variable "db_host" {
#   type = string
#   description = "Database host"
# }

# variable "db_port" {
#   type = string
#   description = "Database port"
# }

# variable "db_username" {
#   type = string
#   description = "Database username"
# }

# variable "db_password" {
#   type = string
#   description = "Database password"
# }

# variable "db_name" {
#   type = string
#   description = "Database name"
# }

# variable "cloudwatch_log_group" {
#   type = string
#   description = "Cloudwatch log group"
# }

variable "ecs_desired_count" {
  type        = number
  description = "ECS desired count"
}

variable "lb_security_groups" {
  type        = list(string)
  description = "Load Balancer security groups"
}

variable "lb_subnets" {
  type        = list(string)
  description = "Load Balancer security groups"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
}
