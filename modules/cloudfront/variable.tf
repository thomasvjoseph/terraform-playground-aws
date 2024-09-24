variable "cloudfront_resources" {
  description = "Map of cloudfront configurations"
  type = map(object({
    cloudfront_description  = string
    s3_bucket_domain_name   = string
    s3_bucket_name          = string
  }))
}
variable "bucket_name" {
  type = string
}

variable "name" {
  type = string
}

variable "env" {
  type = string
}

variable "cloudfront_description" {
  type = string
}