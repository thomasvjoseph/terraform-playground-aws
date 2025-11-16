variable "vpc_id" {
  description = "VPC ID for the load balancer and target groups"
  type        = string
}

variable "lb_resources" {
  description = "Load Balancer resources definition (can have multiple)"
  type = map(object({
    lb_name                    = string
    subnets                    = list(string)
    lb_security_group          = list(string)
    lb_target_type             = string
    internal                   = bool
    tg_name                    = string
    tg_port_number             = number
    lb_port_number             = number
    lb_target_id               = list(string)
    load_balancer_type         = string
    enable_deletion_protection = bool
    tags                       = map(string)
    use_for                    = string # EC2 or ECS
  }))
}

variable "lb_target_groups" {
  description = "Target group definitions (multiple TGs per ALB)"
  type = map(object({
    lb_key          = string
    tg_name         = string
    tg_port_number  = number
    tg_path_pattern = list(string)
    priority        = number
    use_for         = string
    lb_target_id    = list(string)
    tags            = map(string)
  }))
}