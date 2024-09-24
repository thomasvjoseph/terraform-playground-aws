output "ecr_repository_name" {
    value = aws_ecr_repository.app.name
}
  
output "url" {
    value = aws_ecr_repository.app.repository_url
  
}