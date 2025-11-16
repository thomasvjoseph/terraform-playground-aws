output "public_IP" {
  value = { for k, v in aws_instance.ec2_instance : k => v.public_ip }
}

output "private_IP" {
  value = { for k, v in aws_instance.ec2_instance : k => v.private_ip }
}

output "instance_name" {
  value = { for k, v in aws_instance.ec2_instance : k => v.tags.Name }
}

output "instance_id" {
  value = { for k, v in aws_instance.ec2_instance : k => v.id }
}

output "instance_arn" {
  value = { for k, v in aws_instance.ec2_instance : k => v.arn }
}

# Add this new combined output for CloudWatch
output "instances_for_monitoring" {
  description = "Map of instance IDs to instance names for CloudWatch monitoring"
  value = { for k, v in aws_instance.ec2_instance :
    v.id => v.tags.Name
  }
}