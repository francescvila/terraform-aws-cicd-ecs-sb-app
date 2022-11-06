output "load_balancer" {
  value = aws_alb.load_balancer
}

output "target_group" {
  value = aws_alb_target_group.target_group
}

output "dns_name" {
  value = aws_alb.load_balancer.dns_name
}
