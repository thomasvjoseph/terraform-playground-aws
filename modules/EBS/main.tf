resource "aws_ebs_volume" "tf_volume" {
  availability_zone = var.availability_zone
  size              = var.ebs_size

  tags = {
    Name = "${var.name}-ebs"
    Env  = var.env
  }
}

resource "aws_volume_attachment" "tf_volume_attachment" {
  device_name = var.ebs_device_name
  volume_id   = aws_ebs_volume.tf_volume.id
  instance_id = var.instance_id
}