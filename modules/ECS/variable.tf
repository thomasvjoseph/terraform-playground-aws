variable "ecs_resources" {
  type = map(object({
    ecs_cluster_name                  = string
    name                              = string
    env                               = string
    ecs_task_def_family               = string
    ecs_task_def_network_mode         = string
    ecs_task_requires_compatibilities = list(string)
    ecs_os_family                     = string
    ecs_cpu_architecture              = string
    ecs_task_def_cpu                  = number
    ecs_task_def_memory               = number
    ecs_task_def_task_role_arn        = string
    ecs_task_def_execution_role_arn   = string
    ecs_task_def_container_name       = string
    #ecs_image_url                     = string
    ecs_container_cpu                 = number
    ecs_container_memory_reservation  = number
    ecs_task_def_container_port       = number
    ecs_task_def_host_port            = number
    ecs_awslogs_group                 = string
    aws_region                        = string
    ecs_service_name                  = string
    ecs_launch_type                   = string
    ecs_desired_count                 = number
    ecs_security_group                = list(string)
    ecs_target_group_arn              = optional(string, "")  # Optional and defaults to an empty string
    ecs_service_container_name        = string
    ecs_service_container_port        = number
  }))
}

variable "subnet1_id" {
  type        = string
  description = "ID of subnet 1"
}

variable "subnet2_id" {
  type        = string
  description = "ID of subnet 2"
}

variable "subnet3_id" {
  type        = string
  description = "ID of subnet 3"
}

variable "ecs_asg_max_size" {
  type = number
}

variable "ecs_asg_min_size" {
  type = number
}