# Create the Interface VPC Endpoint for Amazon CloudWatch Logs
resource "aws_vpc_endpoint" "cloudwatch_logs" {
  count = var.create_cloudwatch_logs_endpoint ? 1 : 0

  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.logs"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.subnet_ids
  security_group_ids  = var.security_group_ids
  private_dns_enabled = true

  tags = {
    Serice      = "cloudwatch-logs-endpoint"
    Environment = var.environment
  }
}

# Create the Interface VPC Endpoint for Amazon ECR API
resource "aws_vpc_endpoint" "ecr_api" {
  count = var.create_ecr_api_endpoint ? 1 : 0

  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.ecr.api"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.subnet_ids
  security_group_ids  = var.security_group_ids
  private_dns_enabled = true

  tags = {
    Serice      = "ecr-api-endpoint"
    Environment = var.environment
  }
}

# Create the Interface VPC Endpoint for Amazon ECR Docker Registry
resource "aws_vpc_endpoint" "ecr_dkr" {
  count = var.create_ecr_dkr_endpoint ? 1 : 0

  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.subnet_ids
  security_group_ids  = var.security_group_ids
  private_dns_enabled = true

  tags = {
    Serice      = "ecr-dkr-endpoint"
    Environment = var.environment
  }
}

# Create the Gateway VPC Endpoint for Amazon S3
resource "aws_vpc_endpoint" "s3_gateway" {
  count = var.create_s3_gateway_endpoint ? 1 : 0

  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.aws_region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = var.route_table_ids

  tags = {
    Serice      = "s3-gateway-endpoint"
    Environment = var.environment
  }
}
