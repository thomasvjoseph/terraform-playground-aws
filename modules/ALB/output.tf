#############################################
# ALB Outputs
#############################################

output "alb_name" {
  description = "The name of each load balancer"
  value       = { for k, v in aws_lb.load_balancer : k => v.name }
}

output "alb_dns_name" {
  description = "The DNS name of each load balancer"
  value       = { for k, v in aws_lb.load_balancer : k => v.dns_name }
}

output "alb_arn" {
  description = "The ARN of each load balancer"
  value       = { for k, v in aws_lb.load_balancer : k => v.arn }
}

#############################################
# Target Group Outputs
#############################################

output "target_group_arn" {
  description = "The ARN of each target group"
  value       = { for k, v in aws_lb_target_group.target_group : k => v.arn }
}

output "target_group_name" {
  description = "The name of each target group"
  value       = { for k, v in aws_lb_target_group.target_group : k => v.name }
}
