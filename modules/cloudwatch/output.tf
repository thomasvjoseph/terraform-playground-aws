output "cloudwatch_log_group_names" {
  value = { for k, v in aws_cloudwatch_log_group.cw_log_group : k => v.name }
}

output "cloudwatch_log_stream_names" {
  value = { for k, v in aws_cloudwatch_log_stream.cw_log_group_stream : k => v.name }
}

output "cloudwatch_log_arn" {
  value = { for k, v in aws_cloudwatch_log_group.cw_log_group : k => v.arn }
  
}

