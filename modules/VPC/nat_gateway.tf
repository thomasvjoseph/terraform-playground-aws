# Create Elastic IP for NAT Gateway
resource "aws_eip" "nat_eip" {
  domain = "vpc"
  tags = {
    Name        = "${var.vpc_name}-nat-eip"
    "Env"       = var.vpc_env
    "Terraform" = "true"
  }
}

# Create NAT Gateway in one of the public subnets (select the first public subnet)
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id

  # Select the first public subnet from the map of subnets
  subnet_id = element([for k, v in aws_subnet.subnets : v.id if v.map_public_ip_on_launch], 0)

  depends_on = [aws_eip.nat_eip]

  tags = {
    Name        = "${var.vpc_name}-nat-gw"
    "Env"       = var.vpc_env
    "Terraform" = "true"
  }
}

# Add a route in the private route table to use the NAT Gateway for internet traffic
resource "aws_route" "private_nat_route" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw.id

  depends_on = [aws_nat_gateway.nat_gw]
}