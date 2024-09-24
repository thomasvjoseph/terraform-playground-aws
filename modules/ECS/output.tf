output "ecs_cluster_name" {
  value = { for k, v in aws_ecs_cluster.ecs_cluster : k => v.name }
}

output "ecs_task_definition_arn" {
  value = { for k, v in aws_ecs_task_definition.ecs_task_definition : k => v.arn }
}

output "ecs_service_name" {
  value = { for k, v in aws_ecs_service.ecs_service : k => v.name }
}

output "ecs_service_arn" {
  description = "The ARN of the ECS service"
  value       = { for k, v in aws_ecs_service.ecs_service : k => v.id }
  depends_on  = [aws_ecs_service.ecs_service]
}