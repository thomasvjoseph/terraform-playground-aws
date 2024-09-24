variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "vpc_name" {
  description = "Name for the VPC"
  type        = string
}

variable "vpc_env" {
  description = "Environment for the VPC"
  type        = string
}

variable "internet_gateway_name" {
  description = "Name for the Internet Gateway"
  type        = string
  default     = "i-gateway-2"
}

variable "route_table_name_public" {
  description = "Name for the public route table"
  type        = string
  default     = "public-route-table"
}

variable "route_table_name_private" {
  description = "Name for the private route table"
  type        = string
  default     = "private-route-table"
}

variable "subnet_cidr_blocks" {
  description = "CIDR block for the subnets"
  type        = map(object({
    subnet_cidr_block    = string
    availability_zone    = string
    ipv6_address         = bool
    ip4_address          = bool
    sub_name             = string
  }))
}

variable "db_subnet_group_name" {
  description = "Name for the DB subnet group"
  type        = string
}
