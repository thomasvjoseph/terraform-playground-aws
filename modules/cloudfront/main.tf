resource "aws_cloudfront_origin_access_identity" "cf_oai" {
  for_each                    = var.cloudfront_resources
  comment                     = each.value.s3_bucket_domain_name
}

resource "aws_cloudfront_distribution" "cloudfront_distribution" {
  for_each                    = var.cloudfront_resources
  origin {
    domain_name               =  each.value.s3_bucket_domain_name
    origin_id                 =  each.value.s3_bucket_name
    s3_origin_config { 
      origin_access_identity  = aws_cloudfront_origin_access_identity.cf_oai[each.key].cloudfront_access_identity_path
    }
  }
  enabled                     = true
  is_ipv6_enabled             = true
  default_root_object         = "index.html"

    default_cache_behavior {
    allowed_methods           = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods            = ["GET", "HEAD"]
    target_origin_id          = each.value.s3_bucket_name

    viewer_protocol_policy    = "redirect-to-https"
    min_ttl                   = 0
    default_ttl               = 3600
    max_ttl                   = 86400

    cache_policy_id           = "658327ea-f89d-4fab-a63d-7e88639e58f6"
  }  

  restrictions {
    geo_restriction {
      restriction_type        = "none"
    }
  }
  custom_error_response {
    error_code                = 403
    response_code             = 200
    response_page_path        = "/index.html"
    error_caching_min_ttl     = 10
  }
    viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags                        = {
    Environment               = "production"
    Terraform                 = "true"
  }
  comment                     = each.value.cloudfront_description
}

###Bucket for Assests
resource "aws_s3_bucket" "s3_assets" {
  bucket                    = var.bucket_name
  force_destroy             = true
  tags = {
    Name                    = var.name
    Environment             = var.env
    Terraform               = "true"
  }
}

resource "aws_s3_bucket_policy" "s3_policy" {
  bucket                    = aws_s3_bucket.s3_assets.id
  policy                    = data.aws_iam_policy_document.s3_policy.json
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    effect                  = "Allow"
    principals {
      type                  = "*"
      identifiers           = ["*"]
    }
    actions                 = [
      "s3:GetObject"
    ]
    resources               = [ 
      aws_s3_bucket.s3_assets.arn,
      "${aws_s3_bucket.s3_assets.arn}/*"
    ]
    condition {
      test                  = "StringEquals"
      variable              = "aws:SourceArn"
      values                = [aws_cloudfront_distribution.cf_distribution.arn]
    }
  } 
}

resource "aws_cloudfront_origin_access_control" "cf_oac" {
  name                        = "cf-oac"
  description                 = "cloudfront origin access control"
  origin_access_control_origin_type = "s3"
  signing_behavior             = "always"
  signing_protocol            = "sigv4"
  
}

resource "aws_cloudfront_response_headers_policy" "cf_response_headers_policy" {
  name                        = "cf-response-headers-policy"
  comment                     = "response headers policy"
  cors_config {
    access_control_allow_credentials = false

    access_control_allow_headers {
      items = ["*"]
    }
    access_control_allow_methods {
      items = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    }
    access_control_allow_origins {
      items = ["*"]
      
    }
    access_control_max_age_sec = 600
    origin_override         = true
  }
}

resource "aws_cloudfront_distribution" "cf_distribution" {
  origin {
    domain_name             = aws_s3_bucket.s3_assets.bucket_domain_name
    origin_id               = aws_s3_bucket.s3_assets.bucket
    origin_access_control_id = aws_cloudfront_origin_access_control.cf_oac.id
  }
  enabled = true
  default_cache_behavior {
    allowed_methods           = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods            = ["GET", "HEAD"]
    target_origin_id          = aws_s3_bucket.s3_assets.bucket

    viewer_protocol_policy    = "https-only"
    min_ttl                   = 0
    default_ttl               = 3600
    max_ttl                   = 86400

    cache_policy_id           = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    response_headers_policy_id = aws_cloudfront_response_headers_policy.cf_response_headers_policy.id
  }
  restrictions {
    geo_restriction {
      restriction_type        = "none"
    }
  }
  viewer_certificate {
    cloudfront_default_certificate = true
  }
  comment                     = var.cloudfront_description
}