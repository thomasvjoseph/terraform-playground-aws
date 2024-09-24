output "ebs_volume_id" {
    value = aws_ebs_volume.tf_volume.id
}
  
output "device_name" {
    value = aws_volume_attachment.tf_volume_attachment.device_name
}