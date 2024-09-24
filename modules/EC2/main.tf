resource "aws_iam_instance_profile" "ec2-profile" {
  name                        = var.iam_instance_profile
  role                        = var.ec2_iam_role
}

resource "aws_instance" "demo_instance" {
  for_each                    = var.ec2_resources
  ami                         = each.value.ami_id
  instance_type               = each.value.instance_type
  availability_zone           = each.value.availability_zone
  associate_public_ip_address = true
  subnet_id                   = each.value.subnet_id
  vpc_security_group_ids      = each.value.vpc_security_group_id
  key_name                    = var.key_pair_name
  iam_instance_profile        = aws_iam_instance_profile.ec2-profile.name

  ebs_block_device {
    device_name               = var.ebs_device_name
    volume_size               = var.ebs_size
    volume_type               = "gp3"
    delete_on_termination     = true
    encrypted                 = false
  }

  tags  = {
    "Name"                    = each.value.name
    "Env"                     = each.value.env
    "Terraform"               = "true"
  }
}