variable "ec2_resources" {
  description = "Map of EC2 configurations"
  type        = map(object({
    ami_id    = string
    instance_type = string
    availability_zone = string
    vpc_security_group_id = list(string)
    subnet_id = string
    name = string
    env = string
  }))
}

variable "key_pair_name" {
  type = string
}
variable "ebs_size" {
  type = number
  description = "value of the size of the ebs volume"
}

variable "ebs_device_name" {
  type = string
  description = "value of the device name of ebs volume"
}

variable "ec2_iam_role" {
  type = string
  description = "value of the iam role"
}

variable "iam_instance_profile" {
  type = string
  description = "value of the iam instance profile"
}