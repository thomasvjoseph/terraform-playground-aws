
# VPC
resource "aws_vpc" "vpc-main" {
  cidr_block                   = var.vpc_cidr_block
  assign_generated_ipv6_cidr_block = false
  instance_tenancy            = "default"
  enable_dns_hostnames        = true
  enable_dns_support          = true
  tags = {
    "Name" = var.vpc_name 
    "Env"  = var.vpc_env
    "Terraform" = "true"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "i-gw" {
  vpc_id = aws_vpc.vpc-main.id
  tags = {
    Name = var.internet_gateway_name
    "Env"  = var.vpc_env
    "Terraform" = "true"
  }
}

# subnets
resource "aws_subnet" "subnets" {
  vpc_id                            = aws_vpc.vpc-main.id
  for_each                          = var.subnet_cidr_blocks
  cidr_block                        = each.value.subnet_cidr_block
  availability_zone                 = each.value.availability_zone
  assign_ipv6_address_on_creation   = each.value.ipv6_address
  map_public_ip_on_launch           = each.value.ip4_address
  tags = {
    "Name"                          = each.value.sub_name
    "Env"                           = var.vpc_env
    "Terraform"                     = "true"
  }
}

# Route Tables
resource "aws_route_table" "public" {
  vpc_id                            = aws_vpc.vpc-main.id
  route {
    cidr_block                      = "0.0.0.0/0"
    gateway_id                      = aws_internet_gateway.i-gw.id
  }
  tags = {
    Name =                          "${var.vpc_name}-public"
    "Env"                           = var.vpc_env
    "Terraform"                     = "true"
  }
}

resource "aws_route_table" "private" {
  vpc_id                            = aws_vpc.vpc-main.id
  tags = {
    Name                            = "${var.vpc_name}-private"
    "Env"                           = var.vpc_env
    "Terraform"                     = "true"
  }
}

# Route Table Associations
resource "aws_route_table_association" "public" {
  for_each                          = { for k, v in aws_subnet.subnets : k => v if v.map_public_ip_on_launch }
  subnet_id                         = each.value.id
  route_table_id                    = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  for_each                          = { for k, v in aws_subnet.subnets : k => v if !v.map_public_ip_on_launch }
  subnet_id                         = each.value.id
  route_table_id                    = aws_route_table.private.id
}

# DB Subnet Group
resource "aws_db_subnet_group" "db_subnet_group" {
  name                              = "${var.vpc_name}-db-subnet-group"
  subnet_ids                        = [for s in aws_subnet.subnets : s.id if s.map_public_ip_on_launch]
  tags = {
    Name = "${var.vpc_name}-db-subnet-group"
    "Env"  = var.vpc_env
    "Terraform" = "true"
  }
}