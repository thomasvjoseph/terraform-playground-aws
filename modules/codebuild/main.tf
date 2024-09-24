resource "aws_codebuild_source_credential" "codebuild_source_credential" {
  auth_type   = var.auth_type
  server_type = var.repository_type
  token       = var.repository_token
  user_name   = var.repository_username
}

data "aws_iam_policy_document" "assume_role" {
  for_each = var.codebuild_projects
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "codebuild_iam_role" {
  for_each           = var.codebuild_projects
  name               = "${each.value.codebuild_iam_role_name}-service-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role[each.key].json
}

data "aws_iam_policy_document" "codebuild_iam_policy" {
  for_each = var.codebuild_projects

  statement {
    effect  = "Allow"
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketAcl",
      "s3:GetBucketLocation",
      "s3:DeleteObjectVersion",
      "s3:ListBucket",
      "s3:DeleteObject",
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "cloudfront:GetDistribution",
      "cloudfront:CreateInvalidation",
      "codebuild:CreateReportGroup",
      "codebuild:CreateReport",
      "codebuild:UpdateReport",
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild"
    ]
    resources = [
      each.value.s3_bucket_arn,
      "${each.value.s3_bucket_arn}/*",
      each.value.cloudfront_distribution_arn,
      each.value.cloudwatch_logs_arn,
      "${each.value.cloudwatch_logs_arn}:*",
      "${aws_codebuild_project.codebuild_project[each.key].arn}-*"
    ]
  }
}

resource "aws_iam_role_policy" "codebuild_iam_role_policy" {
  for_each = var.codebuild_projects

  name   = "${each.value.codebuild_iam_role_name}-policy"
  role   = aws_iam_role.codebuild_iam_role[each.key].id
  policy = data.aws_iam_policy_document.codebuild_iam_policy[each.key].json
}
 
resource "aws_codebuild_project" "codebuild_project" {
  for_each      = var.codebuild_projects

  name          = each.value.codebuild_project_name
  description   = each.value.codebuild_prjct_desc
  build_timeout = 5
  service_role  = aws_iam_role.codebuild_iam_role[each.key].arn

  artifacts {
    type                = "NO_ARTIFACTS"
  }
  environment {
    compute_type        = var.codebuild_compute_type
    image               = var.codebuild_image
    type                = var.codebuild_type
    environment_variable {
      name              = "SOME_KEY1"
      value             = "SOME_VALUE1"
    }
  }
  logs_config {
    cloudwatch_logs {
      group_name        = each.value.cloudwatch_log_group_name
      stream_name       = each.value.cw_lg_stream_name
    }
  }
  source {
    type                = var.repository_type
    location            = each.value.source_location
    git_clone_depth     = 1
  }
  source_version        = each.value.source_version
  tags = {
    Environment         = "Test"
    Terraform = "true"
  }
}

resource "aws_codebuild_webhook" "codebuild_webhook_fe" {
  for_each            = var.codebuild_projects
  project_name        = aws_codebuild_project.codebuild_project[each.key].name
  filter_group {
    filter {
      type            = "EVENT"
      pattern         = "PUSH,PULL_REQUEST_MERGED"
    }
    filter {
      type            = "HEAD_REF"
      pattern         = "^refs/heads/main$"
    }
  }
}

resource "aws_iam_role" "codebuild_iam_be_role" {
  name = var.codebuild_iam_role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
      },
    ]
  })
}

###Code Buil IAM role for BE project
resource "aws_iam_policy" "codebuild_iam_be_role_policy" {
  name = var.codebuild_iam_role_policy_name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ecs:UpdateService",
          "logs:CreateLogGroup",
          "logs:PutLogEvents",
          "codebuild:CreateReportGroup",
          "codebuild:CreateReport",
          "logs:CreateLogStream",
          "codebuild:UpdateReport",
          "codebuild:BatchPutCodeCoverages",
          "codebuild:BatchPutTestCases"
        ]
        Effect   = "Allow"
        Resource = [
          "${var.cloudwatch_logs_arn}",
          "${var.cloudwatch_logs_arn}:*",
          "${var.ecs_service_arn}",
          "${var.ecs_service_arn}:*",
          "${aws_codebuild_project.codebuild_project_be.arn}-*"
        ]
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "codebuild_iam_be_role_policy_attach" {
  role       = aws_iam_role.codebuild_iam_be_role.name
  policy_arn = aws_iam_policy.codebuild_iam_be_role_policy.arn
}

resource "aws_iam_role_policy_attachment" "ecr_full_access_attach" {
  role       = aws_iam_role.codebuild_iam_be_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}

resource "aws_codebuild_project" "codebuild_project_be" {
  name          = var.codebuild_project_name
  description   = var.codebuild_prjct_desc
  build_timeout = 5
  service_role  = aws_iam_role.codebuild_iam_be_role.arn

  artifacts {
    type                = "NO_ARTIFACTS"
  }
  environment {
    compute_type        = var.codebuild_compute_type
    image               = var.codebuild_image
    type                = var.codebuild_type
  }
  logs_config {
    cloudwatch_logs {
      group_name        = var.cloudwatch_log_group_name
      stream_name       = var.cw_lg_stream_name
    }
  }
  source {
      type              = var.repository_type
      location          = var.source_location
      git_clone_depth   = 1
    }
  source_version        = var.source_version
  
  tags = {
    Environment         = "Test"
    Terraform           = "true"
  }
}

resource "aws_codebuild_webhook" "aws_codebuild_webhook_be" {
  project_name          = aws_codebuild_project.codebuild_project_be.name
  build_type            = "BUILD"
  filter_group {
    filter {
      type              = "EVENT"
      pattern           = "PUSH,PULL_REQUEST_MERGED"
    }
    filter {
      type              = "HEAD_REF"
      pattern           = "^refs/heads/main$"
    }
  }
}