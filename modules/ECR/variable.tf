variable "image_tag_mutability" {
  type        = string
  description = "The tag mutability setting for the repository (defaults to IMMUTABLE)"
}

variable "app" {
  type = string
  description = "Name of ECR repository"
}
   