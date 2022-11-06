output "ecr_repository_url" {
  value = aws_ecr_repository.ecr_repository.repository_url
}

output "ecs_cluster" {
  value = aws_ecs_cluster.ecs_cluster
}

output "ecs_service" {
  value = aws_ecs_service.ecs_service
}
