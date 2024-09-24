output "codebuild_project_arn" {
    value = { for k, v in aws_codebuild_project.codebuild_project : k => v.arn }
}
output "codebuild_web_iam_role_arn" {
  value = { for k, v in aws_iam_role.codebuild_iam_role : k => v.arn }
}

output "codebuild_arn"{
  value = aws_codebuild_project.codebuild_project_be.arn
}