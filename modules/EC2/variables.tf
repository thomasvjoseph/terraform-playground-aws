variable "ec2_resources" {
  description = "Map of EC2 configurations"
  type = map(object({
    ami_id                  = string
    instance_type           = string
    availability_zone       = string
    security_group_ids      = list(string)
    subnet_id               = string
    associate_public_ip     = bool
    use_ebs_block           = optional(bool, false) # Use EBS block storage
    ebs_size                = number
    tags                    = map(string)
    enable_iam_profile      = optional(bool, false) # Attach IAM role only if true
    user_data               = optional(string, "")  # User data script for instance initialization
  }))
}

variable "key_pair_name" {
  type = string
}

variable "root_volume_size" {
  type        = number
  description = "Size of the root EBS volume in GB"
}

variable "ebs_device_name" {
  type        = string
  description = "Device name of EBS volume"
}

variable "ebs_volume_type" {
  type        = string
  description = "Type of EBS volume"
  default     = "gp3"
  validation {
    condition     = contains(["gp2", "gp3", "io1", "io2", "st1", "sc1"], var.ebs_volume_type)
    error_message = "Invalid EBS volume type. Allowed values: gp2, gp3, io1, io2, st1, sc1."
  }
}

variable "ec2_iam_role" {
  type        = string
  description = "IAM role to attach if EC2 requires it"
  default     = null
}

variable "iam_instance_profile" {
  type        = string
  description = "IAM instance profile name to attach to EC2"
  default     = null
}

variable "delete_on_termination" {
  type        = bool
  description = "Delete EBS volume on instance termination"
  default     = true
  validation {
    condition     = contains([true, false], var.delete_on_termination)
    error_message = "Invalid value for delete_on_termination. Allowed values: true, false."
  }
}

variable "encrypted" {
  type        = bool
  description = "Encrypt EBS volume"
  default     = false
  validation {
    condition     = contains([true, false], var.encrypted)
    error_message = "Invalid value for encrypted. Allowed values: true, false."
  }
  
}