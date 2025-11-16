# Interface endpoints
output "cloudwatch_logs_endpoint_id" {
  value       = aws_vpc_endpoint.cloudwatch_logs[*].id
  description = "ID of the CloudWatch Logs VPC endpoint"
}

output "cloudwatch_logs_endpoint_dns" {
  value       = aws_vpc_endpoint.cloudwatch_logs[*].dns_entry
  description = "DNS entries for CloudWatch Logs endpoint"
}

output "ecr_api_endpoint_id" {
  value       = aws_vpc_endpoint.ecr_api[*].id
  description = "ID of the ECR API VPC endpoint"
}

output "ecr_api_endpoint_dns" {
  value       = aws_vpc_endpoint.ecr_api[*].dns_entry
  description = "DNS entries for ECR API endpoint"
}

output "ecr_dkr_endpoint_id" {
  value       = aws_vpc_endpoint.ecr_dkr[*].id
  description = "ID of the ECR Docker endpoint"
}

output "ecr_dkr_endpoint_dns" {
  value       = aws_vpc_endpoint.ecr_dkr[*].dns_entry
  description = "DNS entries for ECR Docker endpoint"
}

output "ssm_endpoint_id" {
  value       = aws_vpc_endpoint.ssm[*].id
  description = "ID of the SSM VPC endpoint"
}

output "ssm_endpoint_dns" {
  value       = aws_vpc_endpoint.ssm[*].dns_entry
  description = "DNS entries for SSM endpoint"
}

output "ssmmessages_endpoint_id" {
  value       = aws_vpc_endpoint.ssmmessages[*].id
  description = "ID of the SSM Messages VPC endpoint"
}

output "ssmmessages_endpoint_dns" {
  value       = aws_vpc_endpoint.ssmmessages[*].dns_entry
  description = "DNS entries for SSM Messages endpoint"
}

output "ec2messages_endpoint_id" {
  value       = aws_vpc_endpoint.ec2messages[*].id
  description = "ID of the EC2 Messages VPC endpoint"
}

output "ec2messages_endpoint_dns" {
  value       = aws_vpc_endpoint.ec2messages[*].dns_entry
  description = "DNS entries for EC2 Messages endpoint"
}

# Gateway endpoint
output "s3_gateway_endpoint_id" {
  value       = aws_vpc_endpoint.s3_gateway[*].id
  description = "ID of the S3 Gateway endpoint"
}

output "secretsmanager_endpoint_id" {
  value       = aws_vpc_endpoint.secretsmanager[*].id
  description = "ID of the Secrets Manager VPC endpoint"
}

output "iam_endpoint_id" {
  value       = aws_vpc_endpoint.sts[*].id
  description = "ID of the IAM VPC endpoint"
}