#ECS IAM role
variable "ecs_iam_role_name" {
  type        = string
  description = "Name of IAM role for ECS"
}

variable "ecs_iam_policy_name" {
  type        = string
  description = "Name of IAM role policy for ECS"
}

#EC2 IAM role
variable "ec2_iam_role_name" {
  type        = string
  description = "Name of IAM role for ECS"
}

variable "ec2_iam_policy_name" {
  type        = string
  description = "Name of IAM role policy for ECS"
}

variable "create_ec2_iam_role" {
  type = bool
}

variable "create_ecs_iam_role" {
  type = bool
}
