resource "aws_cloudwatch_log_group" "cw_log_group" {
  for_each          = var.cloudwatch_resources
  name              = each.value.cloudwatch_log_name
  retention_in_days = 7

  tags = {
    Environment = each.value.cl_lg_name
    Application = each.value.cl_lg_app
    Terraform   = "true"
  }
}

resource "aws_cloudwatch_log_stream" "cw_log_group_stream" {
  for_each       = var.cloudwatch_resources
  name           = each.value.cw_lg_stream_name
  log_group_name = aws_cloudwatch_log_group.cw_log_group[each.key].name
}
 