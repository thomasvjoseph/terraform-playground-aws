variable "dashboard_name_prefix" { type = string }
variable "environment" { type = string }
variable "region" { type = string }

variable "widget_width" { 
  type = number 
  default = 12 
  }

variable "widget_height" { 
  type = number 
  default = 6 
  }

variable "ec2_instances" {
  type = map(string)
  default = {}
}

variable "rds_instances" {
  type = list(string)
  default = []
}

variable "load_balancers" {
  type = list(object({
    alb_name      = string
    target_groups = list(string)
  }))
  default = []
}

variable "ecs_clusters" {
  type = list(string)
  default = []
}

variable "s3_buckets" {
  type = list(string)
  default = []
}

variable "cloudfront_distributions" {
  type = list(string)
  default = []
}

variable "ses_identities" {
  type = list(string)
  default = []
}

# Toggles
variable "enable_ec2_dashboard" { 
  type = bool 
  default = false 
}

variable "enable_rds_dashboard" { 
  type = bool 
  default = false 
}

variable "enable_alb_dashboard" { 
  type = bool 
  default = false 
}

variable "enable_ecs_dashboard" { 
  type = bool 
  default = false 
}

variable "enable_s3_dashboard" { 
  type = bool 
  default = false 
}

variable "enable_cloudfront_dashboard" { 
  type = bool 
  default = false 
}
variable "enable_ses_dashboard" { 
  type = bool 
  default = false 
}
