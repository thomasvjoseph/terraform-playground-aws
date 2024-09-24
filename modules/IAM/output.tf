output "ec2_iam_role_name" {
  value = length(aws_iam_role.ec2_role) > 0 ? aws_iam_role.ec2_role[0].name : ""
}

output "ec2_iam_role_arn" {
    value = length(aws_iam_role.ec2_role) > 0 ? aws_iam_role.ec2_role[0].arn : ""
}

output "ecs_iam_role_name" {
  value = length(aws_iam_role.ecs_role) > 0 ? aws_iam_role.ecs_role[0].name : ""
}

output "ecs_iam_role_arn" {
  value = length(aws_iam_role.ecs_role) > 0 ? aws_iam_role.ecs_role[0].arn : ""
}

output "ecs_iam_policy_name" {
  value = length(aws_iam_policy.ecs_task_iam_policy) > 0 ? aws_iam_policy.ecs_task_iam_policy[0].name : ""
}

output "ecs_iam_policy_arn" {
  value = length(aws_iam_policy.ecs_task_iam_policy) > 0 ? aws_iam_policy.ecs_task_iam_policy[0].arn : ""
}