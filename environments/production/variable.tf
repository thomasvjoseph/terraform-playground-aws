variable "aws_region" {
  type = string
}


############# VPC ################
variable "vpc_name" {
  type = string
}

variable "vpc_cidr_block" {
  type = string
}

variable "vpc_env" {
  type = string
}

variable "availability_zone_1" {
  type = string
}

variable "availability_zone_2" {
  type = string
}

variable "availability_zone_3" {
  type = string
}

variable "subnet1_cidr_block" {
  type = string
}

variable "subnet2_cidr_block" {
  type = string
}

variable "subnet3_cidr_block" {
  type = string
}

variable "subnet4_cidr_block" {
  type = string
}

variable "subnet5_cidr_block" {
  type = string
}

variable "subnet6_cidr_block" {
  type = string
}

variable "subnet1" {
  type = string
}

variable "subnet2" {
  type = string
}

variable "subnet3" {
  type = string
}

variable "subnet4" {
  type = string
}

variable "subnet5" {
  type = string
}

variable "subnet6" {
  type = string
}

variable "db_subnet_group_name" {
  type = string
}

# Tags
variable "name" {
  type = string
}
# Tags
variable "env" {
  type = string
}

###Security Group#####
variable "sg-name1" {
  type = string
}
variable "sg-description1" {
  type = string
}  

variable "sg-name2" {
  type = string
}
variable "sg-description2" {
  type = string
}

variable "sg-name3" {
  type = string
}
variable "sg-description3" {
  type = string
}

variable "sg-name4" {
  type = string
}
variable "sg-description4" {
  type = string
}
variable "sg-name5" {
  type = string
}
variable "sg-description5" {
  type = string
}

#key pair name
 variable "key_pair_name" {
  type = string
}

#IAM
variable "ec2_iam_role_name" {
  type = string
}

variable "ec2_iam_policy_name" {
  type = string
}
variable "ecs_iam_role_name" {
  type = string
}
variable "ecs_iam_policy_name" {
  type = string
}

#LB for ECS
variable "lb_name1" {
  type = string
}
  
variable "load_balancer_type1" {
  type = string
}

variable "tg_name1" {
  type = string
}

variable "tg_port_number1" {
  type = number
}

variable "lb_target_type1" {
  type = string
}

variable "lb_port_number1" {
  type = number
}

variable "listener_port1" {
  type = number
}

############### cloudwatch ################

variable "cloudwatch_log_name1" {
  type = string
}

variable "cl_lg_name1" {
  type = string
}

variable "cl_lg_app1" {
  type = string
}

variable "cw_lg_stream_name1" {
  type = string
}

variable "cloudwatch_log_name2" {
  type = string
}

variable "cl_lg_name2" {
  type = string
}

variable "cl_lg_app2" {
  type = string
}

variable "cw_lg_stream_name2" {
  type = string
}

################ ECS ################

variable "ecs_cluster_name" {
  type = string
  description = "Name of ECS cluster"
}

variable "ecs-name" {
  type = string
  description = "Name of ECS cluster Tag Name"
}
  
variable "ecs-env" {
  type = string
  description = "Name of ECS cluster environment"
}

variable "ecs_task_def_family" {
  type = string
  description = "Name of ECS cluster"
}
  
variable "ecs_task_def_network_mode" {
  type = string  
}

variable "ecs_task_requires_compatibilities" {
  type = list
}

variable "ecs_os_family" {
  type = string
}

variable "ecs_cpu_architecture" {
  type = string
}

variable "ecs_task_def_cpu" {
  type = number
}
  
variable "ecs_task_def_memory" {
  type = number
}

variable "ecs_task_def_container_name" {
  type = string
}

variable "ecs-container-cpu" {
  type = number
  
}

variable "ecs_container_memory_reservation" {
  type = number
  
}
variable "ecs_task_def_container_port" {
  type = number
}

variable "ecs_task_def_host_port" {
  type = number
} 

variable "ecs_service_name" {
  type = string
}

variable "ecs_launch_type" {
  type = string
}

variable "ecs_service_desired_count" {
  type = number
}

variable "ecs_asg_max_size" {
  type = number
}

variable "ecs_asg_min_size" {
  type = number
}

#ECS Service 2
variable "ecs_task_def_family_1" {
  type = string
  description = "Name of ECS cluster"
}

variable "ecs_task_def_cpu_1" {
  type = number
}
  
variable "ecs_task_def_memory" {
  type = number
}

variable "ecs_task_def_container_name" {
  type = string
}

variable "ecs-container-cpu_1" {
  type = number
  
}

variable "ecs_container_memory_reservation" {
  type = number
  
}
variable "ecs_task_def_container_port" {
  type = number
}

variable "ecs_task_def_host_port" {
  type = number
} 

variable "ecs_service_name" {
  type = string
}

variable "ecs_launch_type" {
  type = string
}

variable "ecs_service_desired_count" {
  type = number
}

variable "ecs_asg_max_size" {
  type = number
}

variable "ecs_asg_min_size" {
  type = number
}