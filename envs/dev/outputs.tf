#
# Network
#

output "vpc_id" {
  value = module.network.vpc_id
}

output "vpc_cidr" {
  value = module.network.vpc_cidr
}

output "public_subnets" {
  value = module.network.public_subnets
}

output "app_subnets" {
  value = module.network.app_subnets
}

output "db_subnets" {
  value = module.network.db_subnets
}

#
# Security
#

output "public_security_group" {
  value = module.security.public_security_group
}

output "app_security_group" {
  value = module.security.app_security_group
}

output "db_security_group" {
  value = module.security.db_security_group
}

#
# Database
#

output "db_address" {
  value = module.database.db_address
}

output "db_port" {
  value = module.database.db_port
}

#
# Load Balancer
#

output "load_balancer" {
  value = module.app_lb.load_balancer
}

output "target_group" {
  value = module.app_lb.target_group
}

output "dns_name" {
  value = module.app_lb.dns_name
}

#
# ECS
#

output "ecr_repository_url" {
  value = module.app_ecs.ecr_repository_url
}

output "ecs_cluster" {
  value = module.app_ecs.ecs_cluster
}

output "ecs_service" {
  value = module.app_ecs.ecs_service
}

#
# CloudFront
#

output "cdn_domain_name" {
  value = module.app_cdn.distribution_domain_name
}

#
# Git Repositories
#

output "repository_url_http" {
  value = module.app_repository.repository_url_http
}

output "repository_url_ssh" {
  value = module.app_repository.repository_url_ssh
}

#
# CI/CD Pipelines
#

output "codebuild_name" {
  value = module.app_pipeline.codebuild_name
}

output "codepipeline_name" {
  value = module.app_pipeline.codepipeline_name
}
