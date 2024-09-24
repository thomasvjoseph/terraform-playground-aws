resource "aws_acm_certificate" "cert" {
for_each            = var.acm_certificates
  domain_name       = each.value.domain_name
  validation_method = "DNS"
  tags = {
    Environment = "Dev /QA "
  }
  lifecycle {
    create_before_destroy = true
  }
  key_algorithm = "RSA_2048"
}