data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  azs = slice(data.aws_availability_zones.available.names, 0, max(
    length(var.public_subnet_cidrs), 
    length(var.private_subnet_cidrs))
  )
}

resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block[0]
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = {
    Name = "${var.tags["Name"]}-vpc "
  }
  }

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags   = {
    Name = "${var.tags["Name"]}-igw"
  }
}

resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone       = local.azs[count.index]
  tags                    ={
    Name = "${var.tags["Name"]}-public-subnet-${count.index + 1}"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
  tags   ={
    Name = "${var.tags["Name"]}-public-rt"
  }
}

resource "aws_route_table_association" "public_rt_association" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = local.azs[count.index]
  tags              = {
    Name = "${var.tags["Name"]}-private-subnet-${count.index + 1}"
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id
  tags   = {
    Name = "${var.tags["Name"]}-private-rt"
  }
}

resource "aws_route_table_association" "private_rt_association" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private_rt.id
}

#NAT Gateway and related resources would go here for private subnet internet access

resource "aws_eip" "nat_eip" {
  tags = {
    Name = "${var.tags["Name"]}-nat-eip"
  }
  
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id    = aws_subnet.public[0].id
  tags = {
    Name = "${var.tags["Name"]}-nat-gw"
  }
}
resource "aws_route" "private_internet_access" {
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw.id
}