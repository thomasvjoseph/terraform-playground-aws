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

# Output all subnet IDs
output "subnet_ids" {
  value = { for k, v in aws_subnet.subnets : k => v.id }
}

# Output only public subnet IDs (those with map_public_ip_on_launch = true)
output "public_subnet_ids" {
  value = { for k, v in aws_subnet.subnets : k => v.id if v.map_public_ip_on_launch == true }
}