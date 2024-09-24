
variable "codebuild_projects" {
  description = "A map of objects, each representing a CodeBuild project configuration."
  type = map(object({
    codebuild_project_name    = string
    codebuild_prjct_desc    = string
    
    source_location = string
    source_version  = string
    cloudwatch_log_group_name = string
    cw_lg_stream_name = string
    
    codebuild_iam_role_name         = string
    codebuild_policy_role_name      = string
    codebuild_iam_policy_name       = string
    s3_bucket_arn                   = string
    cloudwatch_logs_arn             = string
    cloudfront_distribution_arn     = string

  }))
}

variable "codebuild_compute_type" {
  type = string 
}

variable "codebuild_image" {
  type = string
}

variable "codebuild_type" {
  type = string
}

variable "repository_type" {
  type = string
}

variable "auth_type" {
  type = string
}

variable "repository_token"{
  type = string
}

variable "repository_username" {
  type = string
}

##Codebuild BE IAM role
variable "codebuild_iam_role_name" {
  type = string
}
    
variable "codebuild_iam_role_policy_name" {
  type = string
}
variable "cloudwatch_logs_arn" {
  type = string
}
variable "ecs_service_arn" {
  type = string
}

#codebuild BE project
variable "codebuild_project_name" {
  type = string
}

variable "codebuild_prjct_desc" {
  type = string
}

variable "cloudwatch_log_group_name" {
  type = string
}
  
variable "cw_lg_stream_name" {
  type = string
}

variable "source_location" {
  type = string
}

variable "source_version" {
  type = string
}