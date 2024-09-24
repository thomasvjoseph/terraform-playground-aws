variable "sg_resources" {
  type = map(object({
    sg_name          = string
    sg_description   = string
    ingress_rules    = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    }))
    egress_rules     = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    }))
  }))
}
variable "vpc_id" {
  type = string  
}