# VPC

# Create a VPC for the region associated with the AZ

resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  enable_classiclink   = false
  tags = var.tags
}

# Public subnets

resource "aws_subnet" "public_subnets" {
  for_each = var.public_subnet_nums

  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "${var.aws_region}${each.key}"
  cidr_block              = "10.${var.subnet_group_num}.${each.value}.0/24"
  map_public_ip_on_launch = "true"
  tags = var.tags
}

# Private subnets

resource "aws_subnet" "app_subnets" {
  for_each = var.app_subnet_nums

  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "${var.aws_region}${each.key}"
  cidr_block              = "10.${var.subnet_group_num}.${each.value}.0/24"
  map_public_ip_on_launch = "true"
  tags = var.tags
}

resource "aws_subnet" "db_subnets" {
  for_each = var.db_subnet_nums

  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "${var.aws_region}${each.key}"
  cidr_block              = "10.${var.subnet_group_num}.${each.value}.0/24"
  map_public_ip_on_launch = "true"
  tags = var.tags
}

# Internet gateway

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id
  tags = var.tags
}

# NAT gateway

resource "aws_eip" "nat" {
  for_each = aws_subnet.public_subnets
  vpc      = true

  lifecycle {
    create_before_destroy = true
  }
  tags = var.tags
}

resource "aws_nat_gateway" "nat_gateway" {
  for_each      = aws_subnet.public_subnets
  subnet_id     = each.value.id
  allocation_id = aws_eip.nat[each.key].id
  tags = var.tags
}

# Route tables

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = var.tags
}


resource "aws_route_table" "app_rt" {
  for_each = var.public_subnet_nums
  vpc_id   = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway[each.key].id
  }

  tags = var.tags
}

# Route table associations

resource "aws_route_table_association" "public_subnet_rt_assoc" {
  for_each       = aws_subnet.public_subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "app_subnet_rt_assoc" {
  for_each       = aws_subnet.app_subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.app_rt[each.key].id
}
