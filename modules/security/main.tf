# Security groups

resource "aws_security_group" "public_security_group" {
  vpc_id      = var.vpc_id
  name        = "${var.project_name}-public-security-group-${var.env}"
  description = "Security group for ELB"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

resource "aws_security_group" "app_security_group" {
  vpc_id      = var.vpc_id
  name        = "${var.project_name}-app-security-group-${var.env}"
  description = "Security group for app on ECS"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = var.app_port
    to_port         = var.app_port
    protocol        = "tcp"
    security_groups = [aws_security_group.public_security_group.id]
  }

  tags = var.tags
}

resource "aws_security_group" "db_security_group" {
  vpc_id      = var.vpc_id
  name        = "${var.project_name}-db-security-group-${var.env}"
  description = "Security group for database on RDS"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    # self        = true
  }

  ingress {
    from_port   = var.db_port
    to_port     = var.db_port
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }

  tags = var.tags  
}

# ECS EC2 role

resource "aws_iam_role" "ecs_ec2_role" {
  name               = "${var.project_name}-ecs-ec2-role-${var.env}"
  assume_role_policy = file("${path.module}/templates/ecs-ec2-role.json.tpl")
}

resource "aws_iam_instance_profile" "ecs_ec2_role" {
  name = "${var.project_name}-ecs-ec2-role-${var.env}"
  role = aws_iam_role.ecs_ec2_role.name
}

resource "aws_iam_role_policy" "ecs_ec2_role_policy" {
  name   = "${var.project_name}-ecs-ec2-role-policy-${var.env}"
  role   = aws_iam_role.ecs_ec2_role.id
  policy = file("${path.module}/templates/ecs-ec2-role-policy.json.tpl")
}

# ECS service role

resource "aws_iam_role" "ecs_service_role" {
  name               = "${var.project_name}-ecs-service-role-${var.env}"
  assume_role_policy = file("${path.module}/templates/ecs-service-role.json.tpl")
}

resource "aws_iam_policy_attachment" "ecs_service_attachment" {
  name       = "${var.project_name}-ecs-service-attachment-${var.env}"
  roles      = [aws_iam_role.ecs_service_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}
