output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "vpc_cidr" {
  value = aws_vpc.vpc.cidr_block
}

output "public_subnets" {
  value = [for subnet in aws_subnet.public_subnets : subnet.id]
}

output "app_subnets" {
  value = [for subnet in aws_subnet.app_subnets : subnet.id]
}

output "db_subnets" {
  value = [for subnet in aws_subnet.db_subnets : subnet.id]
}
