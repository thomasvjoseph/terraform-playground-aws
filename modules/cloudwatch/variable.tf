variable "cloudwatch_resources" {
  type = map(object({
    cloudwatch_log_name  = string
    cl_lg_name           = string
    cl_lg_app            = string
    cw_lg_stream_name    = string
  }))
}