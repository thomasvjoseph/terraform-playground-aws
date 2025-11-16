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
    Name        = "cloudwatch-logs-endpoint"
    Service     = "cloudwatch-logs-endpoint"
    Environment = var.environment
    Terraform   = "true"
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
    Name        = "ecr-api-endpoint"
    Service     = "ecr-api-endpoint"
    Environment = var.environment
    Terraform   = "true"
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
    Name        = "ecr-dkr-endpoint"
    Service     = "ecr-dkr-endpoint"
    Environment = var.environment
    Terraform   = "true"
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
    Name        = "s3-gateway-endpoint"
    Service     = "s3-gateway-endpoint"
    Environment = var.environment
    Terraform   = "true"
  }
}

# STS Interface Endpoint
resource "aws_vpc_endpoint" "sts" {
  count               = var.create_sts_endpoint ? 1 : 0
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.sts"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.subnet_ids
  security_group_ids  = var.security_group_ids
  private_dns_enabled = true

  tags = {
    Name        = "sts-endpoint"
    Service     = "sts-endpoint"
    Environment = var.environment
    Terraform   = "true"
  }
}

# Secrets Manager Interface Endpoint
resource "aws_vpc_endpoint" "secretsmanager" {
  count               = var.create_secretsmanager_endpoint ? 1 : 0
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.secretsmanager"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.subnet_ids
  security_group_ids  = var.security_group_ids
  private_dns_enabled = true

  tags = {
    Name        = "secretsmanager-endpoint"
    Service     = "secretsmanager-endpoint"
    Environment = var.environment
    Terraform   = "true"
  }
}


# SSM Interface Endpoint
resource "aws_vpc_endpoint" "ssm" {
  count               = var.create_ssm_endpoint ? 1 : 0
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.ssm"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.subnet_ids
  security_group_ids  = var.security_group_ids
  private_dns_enabled = true

  tags = {
    Name        = "ssm-endpoint"
    Service     = "ssm-endpoint"
    Environment = var.environment
    Terraform   = "true"
  }
}

# SSM Messages Interface Endpoint
resource "aws_vpc_endpoint" "ssmmessages" {
  count               = var.create_ssmmessages_endpoint ? 1 : 0
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.ssmmessages"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.subnet_ids
  security_group_ids  = var.security_group_ids
  private_dns_enabled = true

  tags = {
    Name        = "ssm-messages-endpoint"
    Service     = "ssm-messages-endpoint"
    Environment = var.environment
    Terraform   = "true"
  }
}

# EC2 Messages Interface Endpoint
resource "aws_vpc_endpoint" "ec2messages" {
  count               = var.create_ec2messages_endpoint ? 1 : 0
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.ec2messages"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.subnet_ids
  security_group_ids  = var.security_group_ids
  private_dns_enabled = true

  tags = {
    Name        = "ec2-messages-endpoint"
    Service     = "ec2-messages-endpoint"
    Environment = var.environment
    Terraform   = "true"
  }
}

