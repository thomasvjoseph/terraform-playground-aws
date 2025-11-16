
resource "aws_iam_role" "ec2_role" {
  count = var.create_ec2_iam_role ? 1 : 0
  name  = var.ec2_iam_role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Principal = {
          Service = [
            "ec2.amazonaws.com"
          ]
        },
        Effect = "Allow",
        Sid    = ""
      }
    ]
  })
  tags = {
    terraform = "true"
  }
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  count = var.create_ec2_iam_role ? 1 : 0
  name  = "${var.ec2_iam_role_name}-profile"
  role  = aws_iam_role.ec2_role[count.index].name
  tags = {
    terraform = "true"
  }
}

resource "aws_iam_policy" "ec2_iam_policy" {
  count = var.create_ec2_iam_role ? 1 : 0
  name  = var.ec2_iam_policy_name
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "secretsmanager:GetResourcePolicy",
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret",
          "secretsmanager:ListSecretVersionIds",
          "secretsmanager:GetRandomPassword",
          "secretsmanager:ListSecrets",
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject",
          "s3:DeleteObjectVersion",
          "s3:ListBucket",
          "s3:DeleteObject",
          "s3:GetBucketLocation",
          "s3:GetObjectVersion"
        ],
        Resource = "*"
      }
    ]
  })
  tags = {
    terraform = "true"
  }
}

resource "aws_iam_role_policy_attachment" "ec2-attach" {
  count      = var.create_ec2_iam_role ? 1 : 0
  role       = aws_iam_role.ec2_role[count.index].name
  policy_arn = aws_iam_policy.ec2_iam_policy[count.index].arn
}

resource "aws_iam_role_policy_attachment" "ssm_core_attach" {
  count      = var.create_ec2_iam_role ? 1 : 0
  role       = aws_iam_role.ec2_role[count.index].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}



resource "aws_iam_role" "ecs_role" {
  count = var.create_ecs_iam_role ? 1 : 0
  name  = var.ecs_iam_role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Principal = {
          Service = [
            "ecs-tasks.amazonaws.com"
          ]
        },
        Effect = "Allow",
        Sid    = ""
      }
    ]
  })
  tags = {
    terraform = "true"
  }
}

resource "aws_iam_policy" "ecs_task_iam_policy" {
  count = var.create_ecs_iam_role ? 1 : 0
  name  = var.ecs_iam_policy_name
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "ssmmessages:CreateControlChannel",
          "ssmmessages:CreateDataChannel",
          "ssmmessages:OpenControlChannel",
          "ssmmessages:OpenDataChannel",
          "secretsmanager:GetResourcePolicy",
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret",
          "secretsmanager:ListSecretVersionIds",
          "secretsmanager:GetRandomPassword",
          "secretsmanager:ListSecrets"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy" {
  count      = var.create_ecs_iam_role ? 1 : 0
  role       = aws_iam_role.ecs_role[count.index].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "ecs-attach" {
  count      = var.create_ecs_iam_role ? 1 : 0
  role       = aws_iam_role.ecs_role[count.index].name
  policy_arn = aws_iam_policy.ecs_task_iam_policy[count.index].arn
}

resource "aws_iam_role_policy_attachment" "s3_ecs_attach" {
  count      = var.create_ecs_iam_role ? 1 : 0
  role       = aws_iam_role.ecs_role[count.index].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "sns_ecs_attach" {
  count      = var.create_ecs_iam_role ? 1 : 0
  role       = aws_iam_role.ecs_role[count.index].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSNSFullAccess"
}