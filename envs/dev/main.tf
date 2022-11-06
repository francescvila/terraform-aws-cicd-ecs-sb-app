# Network: vpc, subnets, internet gateways
module "network" {
  source             = "../../modules/network"
  aws_region         = var.aws_region
  env                = var.env
  project_name       = var.project_name
  vpc_cidr           = var.vpc_cidr
  subnet_group_num   = var.subnet_group_num
  public_subnet_nums = var.public_subnet_nums
  app_subnet_nums    = var.app_subnet_nums
  db_subnet_nums     = var.db_subnet_nums
  tags               = var.tags
}

# Security groups: access restrictions to subnets, ports, resources.
module "security" {
  source       = "../../modules/security"
  aws_region   = var.aws_region
  env          = var.env
  project_name = var.project_name
  vpc_id       = module.network.vpc_id
  vpc_cidr     = var.vpc_cidr
  db_port      = var.db_port
  app_port     = var.app_port
  tags         = var.tags
}

# Database

data "aws_secretsmanager_secret_version" "db_creds" {
  secret_id = var.db_secret_id
}

locals {
  db_creds = jsondecode(
    data.aws_secretsmanager_secret_version.db_creds.secret_string
  )
}

module "database" {
  source                     = "../../modules/database"
  aws_region                 = var.aws_region
  aws_profile                = var.aws_profile
  env                        = var.env
  project_name               = var.project_name
  db_name                    = var.db_name
  db_username                = local.db_creds.username
  db_password                = local.db_creds.password
  db_port                    = var.db_port
  db_subnets                 = module.network.db_subnets
  db_security_groups         = [module.security.db_security_group]
  db_family                  = var.db_family
  db_allocated_storage       = var.db_allocated_storage
  db_max_allocated_storage   = var.db_max_allocated_storage
  db_engine                  = var.db_engine
  db_engine_version          = var.db_engine_version
  db_instance_class          = var.db_instance_class
  db_multi_az                = var.db_multi_az
  db_backup_retention_period = var.db_backup_retention_period
  db_backup_window           = var.db_backup_window
  db_maintenance_window      = var.db_maintenance_window
  tags                       = var.tags
}

# Elastic Load Balancer

module "app_lb" {
  source             = "../../modules/load_balancer"
  env                = var.env
  project_name       = var.project_name
  lb_security_groups = [module.security.public_security_group, module.security.app_security_group]
  lb_subnets         = module.network.public_subnets
  vpc_id             = module.network.vpc_id
  tags               = var.tags
}

# ECR; ECS & tasks

module "app_ecs" {
  source         = "../../modules/ecs"
  aws_region     = var.aws_region
  env            = var.env
  project_name   = var.project_name
  container_port = var.app_port
  # ecs_service_iam_role              = module.security.ecs_service_role_arn
  # ecs_service_iam_policy_attachment = module.security.ecs_service_attachment
  target_group_arn = module.app_lb.target_group.arn
  # db_host                           = module.database.db_address
  # db_port                           = module.database.db_port
  # db_username                       = local.db_creds.username
  # db_password                       = local.db_creds.password
  # db_name                           = var.db_name
  ecs_desired_count  = var.ecs_desired_count
  lb_security_groups = [module.security.app_security_group]
  lb_subnets         = module.network.app_subnets
  # cloudwatch_log_group = module.monitoring.cloudwatch_log_group_id
  tags = var.tags
}

# Autoscaling groups

module "app_autoscaling" {
  source             = "../../modules/autoscaling"
  aws_region         = var.aws_region
  env                = var.env
  project_name       = var.project_name
  ecs_cluster_name   = module.app_ecs.ecs_cluster.name
  ecs_service_name   = module.app_ecs.ecs_service.name
  lb_security_groups = [module.security.app_security_group]
  lb_subnets         = module.network.app_subnets
  vpc_id             = module.network.vpc_id
}

# # Monitoring

# module "monitoring" {
#   source                        = "../../modules/monitoring"
#   aws_region                    = var.aws_region
#   env                           = var.env
#   project_name                  = var.project_name
#   alarm_actions_high_cpu        = [module.app_autoscaling.autoscaling_policy_scale_up_arn]
#   alarm_actions_low_cpu         = [module.app_autoscaling.autoscaling_policy_scale_down_arn]
#   alarm_actions_high_5xx_errors = [module.notifications.sns_topic_arn]
#   autoscaling_group_name        = module.app_autoscaling.ecs_autoscaling_group_name
#   alb_arn_suffix                = module.app_autoscaling.alb_arn_suffix
#   tags                          = var.tags
# }

# # Notifications

# module "notifications" {
#   source              = "../../modules/notifications"
#   aws_region          = var.aws_region
#   env                 = var.env
#   project_name        = var.project_name
#   sns_email_addresses = [var.sns_email_receiver]
#   sns_stack_name      = var.sns_stack_name
#   tags                = var.tags
# }

# CDN: CloudFront

module "app_cdn" {
  source             = "../../modules/cdn"
  aws_region         = var.aws_region
  env                = var.env
  project_name       = var.project_name
  target_domain_name = module.app_lb.dns_name
  origin_id          = "${var.project_name}-${var.env}"
  tags               = var.tags
}

# Git repository for the web application

module "app_repository" {
  source       = "../../modules/repositories"
  env          = var.env
  project_name = var.project_name
  tags         = var.tags
}

# CI/CD pipelines

module "app_pipeline" {
  source             = "../../modules/pipelines"
  aws_region         = var.aws_region
  env                = var.env
  project_name       = var.project_name
  repository_name    = var.app_repository_name
  repository_branch  = var.app_repository_branch
  image_repo_name    = "${var.project_name}-${var.env}"
  ecs_cluster_name   = module.app_ecs.ecs_cluster.name
  ecs_service_name   = module.app_ecs.ecs_service.name
  build_timeout      = var.build_timeout
  queued_timeout     = var.queued_timeout
  build_image        = var.build_image
  build_compute_type = var.build_compute_type
  package_buildspec  = var.package_buildspec
  tags               = var.tags
}
