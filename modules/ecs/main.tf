# ECR

resource "aws_ecr_repository" "ecr_repository" {
  name = "${var.project_name}-${var.env}"
  tags = var.tags
}

# ECS cluster

resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.project_name}-ecs-cluster-${var.env}"
  tags = var.tags
}

resource "aws_ecs_cluster_capacity_providers" "ecs_cluster_capacity_providers" {
  cluster_name = aws_ecs_cluster.ecs_cluster.name

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}

# Task definition 

data "template_file" "task_definition_template" {
  template = file("${path.module}/templates/app.json.tpl")
  vars = {
    aws_region     = var.aws_region
    repository_url = replace(aws_ecr_repository.ecr_repository.repository_url, "https://", "")
    container_port = var.container_port
    project_name       = var.project_name
    # database_host        = var.db_host
    # database_port        = var.db_port
    # database_user        = var.db_username
    # database_password    = var.db_password
    # database_name        = var.db_name
    #cloudwatch_log_group = var.cloudwatch_log_group
  }
}

data "aws_iam_policy_document" "ecs_tasks_execution_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "task_execution_role" {
  name               = "${var.project_name}-task-execution-role-${var.env}"
  assume_role_policy = data.aws_iam_policy_document.ecs_tasks_execution_role.json
}

resource "aws_iam_role_policy_attachment" "task_execution_role_policy" {
  role       = aws_iam_role.task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecs_task_definition" "ecs_task_definition" {
  family                   = "${var.project_name}-${var.env}"
  container_definitions    = data.template_file.task_definition_template.rendered
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "512"
  memory                   = "1024"
  task_role_arn            = aws_iam_role.task_execution_role.arn
  execution_role_arn       = aws_iam_role.task_execution_role.arn
  tags = var.tags
}

# ECS service

resource "aws_ecs_service" "ecs_service" {
  name            = "${var.project_name}-ecs-service-${var.env}"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs_task_definition.arn
  desired_count   = var.ecs_desired_count
  # iam_role        = var.ecs_service_iam_role
  # depends_on      = [var.ecs_service_iam_policy_attachment]
  launch_type      = "FARGATE"
  platform_version = "1.4.0"

  lifecycle {
    ignore_changes = [desired_count]
  }

  network_configuration {
    subnets          = var.lb_subnets
    security_groups  = var.lb_security_groups
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "${var.project_name}"
    container_port   = var.container_port
  }

  tags = var.tags
}

# Set up CloudWatch group and log stream and retain logs for 30 days
resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name              = "/ecs/${var.project_name}"
  retention_in_days = 30
  tags = var.tags
}

resource "aws_cloudwatch_log_stream" "ecs_log_stream" {
  name           = "${var.project_name}-log-stream"
  log_group_name = aws_cloudwatch_log_group.ecs_log_group.name
}
