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

variable "repository_name" {
  type        = string
  description = "Code Commit repository name"
}

variable "repository_branch" {
  type        = string
  description = "Code Commit repository branch"
}

variable "image_repo_name" {
  type        = string
  description = "ECR image repository name"
}

variable "ecs_cluster_name" {
  type        = string
  description = "ECS cluster name"
}

variable "ecs_service_name" {
  type        = string
  description = "ECS service name"
}

variable "build_timeout" {
  type        = string
  description = "The time to wait for a CodeBuild to complete before timing out in minutes (default: 5)"
}

variable "queued_timeout" {
  type        = string
  description = "Number of minutes, from 5 to 480 (8 hours), a build is allowed to be queued before it times out. The default is 8 hours."
}

variable "build_compute_type" {
  type        = string
  description = "The build instance type for CodeBuild (default: BUILD_GENERAL1_SMALL)"
}

variable "build_image" {
  type        = string
  description = "The build image for CodeBuild to use (default: aws/codebuild/nodejs:6.3.1)"
}

variable "package_buildspec" {
  type        = string
  description = "The buildspec to be used for the Package stage (default: buildspec.yml)"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
}
