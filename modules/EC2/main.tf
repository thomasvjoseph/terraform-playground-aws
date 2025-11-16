locals {
  profile_exists = var.iam_instance_profile != null && var.iam_instance_profile != "" ? true : false
}

data "aws_iam_instance_profile" "default" {
  count = local.profile_exists ? 1 : 0
  name  = var.iam_instance_profile
}

resource "aws_iam_instance_profile" "this" {
  count = local.profile_exists && length(data.aws_iam_instance_profile.default) == 0 ? 1 : 0
  name  = var.iam_instance_profile
  role  = var.ec2_iam_role
}


resource "aws_instance" "ec2_instance" {
  for_each = var.ec2_resources

  ami                         = each.value.ami_id
  instance_type               = each.value.instance_type
  availability_zone           = each.value.availability_zone
  subnet_id                   = each.value.subnet_id
  vpc_security_group_ids      = each.value.security_group_ids
  key_name                    = var.key_pair_name
  associate_public_ip_address = each.value.associate_public_ip
  user_data_base64            = each.value.user_data != "" ? base64encode(each.value.user_data) : null

  # Attach IAM profile only if enabled
  iam_instance_profile = lookup(each.value, "enable_iam_profile", false) ? var.iam_instance_profile : null
  root_block_device {
    volume_size = var.root_volume_size
    volume_type = var.ebs_volume_type
    delete_on_termination = var.delete_on_termination
    encrypted = var.encrypted
  }
  dynamic "ebs_block_device" {
    for_each = lookup(each.value, "use_ebs_block", false) ? [1] : []
    content {
      device_name = var.ebs_device_name
      volume_size = each.value.ebs_size
      volume_type = var.ebs_volume_type
      delete_on_termination = var.delete_on_termination
      encrypted = var.encrypted
    }
  }

  tags = each.value.tags
}
