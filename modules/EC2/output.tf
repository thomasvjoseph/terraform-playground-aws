output "public_IP" {
  value = { for k, v in aws_instance.demo_instance : k => v.public_ip }
}
output "instance_id" {
  value = { for k, v in aws_instance.demo_instance : k => v.id }
}

output "instance_arn" {
  value = { for k, v in aws_instance.demo_instance : k => v.arn }
}