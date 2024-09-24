output "vpc_id" {
  value = aws_vpc.vpc-main.id
}

output "vpc_cidr_block" {
  value = aws_vpc.vpc-main.cidr_block
}

output "internet_gateway_id" {
  value = aws_internet_gateway.i-gw.id
}

output "route_table_public_id" {
  value = aws_route_table.public.id
}

output "route_table_private_id" {
  value = aws_route_table.private.id 
}

output "db_subnet_group_name" {
  value = aws_db_subnet_group.db_subnet_group.name
}

output "subnet_id" {
  value = { for k, v in aws_subnet.subnets : k => v.id }
}