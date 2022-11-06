resource "aws_db_subnet_group" "db_subnet_group" {
  name        = "${var.project_name}-db-subnet-group-${var.env}"
  description = "RDS subnet group"
  subnet_ids  = var.db_subnets
  tags = var.tags
}

resource "aws_db_parameter_group" "db_parameters" {
  name        = "${var.project_name}-db-parameters-${var.env}"
  family      = var.db_family
  description = "RDS parameter group"
  tags = var.tags
}

resource "aws_db_instance" "db" {
  allocated_storage       = var.db_allocated_storage
  max_allocated_storage   = var.db_max_allocated_storage
  publicly_accessible     = false
  engine                  = var.db_engine
  engine_version          = var.db_engine_version
  instance_class          = var.db_instance_class
  identifier              = "${var.project_name}-db-${var.env}"
  db_name                 = var.db_name
  username                = var.db_username
  password                = var.db_password
  port                    = var.db_port
  db_subnet_group_name    = aws_db_subnet_group.db_subnet_group.name
  parameter_group_name    = aws_db_parameter_group.db_parameters.name
  multi_az                = var.db_multi_az
  vpc_security_group_ids  = var.db_security_groups
  storage_type            = "gp2"
  backup_retention_period = var.db_backup_retention_period
  backup_window           = var.db_backup_window
  maintenance_window      = var.db_maintenance_window
  skip_final_snapshot     = true
  copy_tags_to_snapshot   = true
  deletion_protection     = true
  tags = var.tags
}

# resource "aws_db_instance_automated_backups_replication" "db_backups_replication" {
#   source_db_instance_arn = aws_db_instance.db.arn
#   retention_period       = 14
#   provider               = aws.replica
# }
