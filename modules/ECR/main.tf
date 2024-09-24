resource "aws_ecr_repository" "app" {
  name                 = var.app
  image_tag_mutability = var.image_tag_mutability
  force_delete         = true
  tags = {
    terraform = "true"
  } 
}

resource "aws_ecr_lifecycle_policy" "main" {
  repository = aws_ecr_repository.app.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last 2 images "
        action = {
          type = "expire"
        }
        selection = {
          tagStatus   = "untagged"
          countType   = "imageCountMoreThan"
          countNumber = 1
        }
      }
    ]
  })
}