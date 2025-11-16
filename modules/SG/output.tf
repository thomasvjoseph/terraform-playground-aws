output "security_group_id" {
  value = { for k, v in aws_security_group.security_group : k => v.id }
}
