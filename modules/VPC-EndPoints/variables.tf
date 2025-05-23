variable "vpc_id" {
  type        = string
  description = "ID of the VPC where the endpoints will be created."
}

variable "aws_region" {
  type        = string
  description = "AWS region where the resources will be created."
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs to attach interface endpoints."
}

variable "security_group_ids" {
  type        = list(string)
  description = "Security group IDs to attach to interface endpoints."
}

variable "route_table_ids" {
  type        = list(string)
  description = "List of route table IDs for gateway endpoints."
}

variable "environment" {
  type        = string
  description = "The environment tag value (e.g., dev, prod)."
}

variable "create_cloudwatch_logs_endpoint" {
  type        = bool
  description = "Flag to create the CloudWatch Logs endpoint."
}

variable "create_ecr_api_endpoint" {
  type        = bool
  description = "Flag to create the ECR API endpoint."
}

variable "create_ecr_dkr_endpoint" {
  type        = bool
  description = "Flag to create the ECR Docker endpoint."

}

variable "create_s3_gateway_endpoint" {
  type        = bool
  description = "Flag to create the S3 Gateway endpoint."
}