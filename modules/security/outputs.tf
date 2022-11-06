output "public_security_group" {
  value = aws_security_group.public_security_group.id
}

output "app_security_group" {
  value = aws_security_group.app_security_group.id
}

output "db_security_group" {
  value = aws_security_group.db_security_group.id
}

output "ecs_service_role_arn" {
  value = aws_iam_role.ecs_service_role.arn
}

output "ecs_service_attachment" {
  value = aws_iam_policy_attachment.ecs_service_attachment
}

output "ecs_ec2_instance_profile" {
  value = aws_iam_instance_profile.ecs_ec2_role.id
}
