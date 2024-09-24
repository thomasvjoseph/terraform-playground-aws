module "vpc"{
  source                          = "../../modules/VPC"
  vpc_name                        = var.vpc_name
  vpc_cidr_block                  = var.vpc_cidr_block
  vpc_env                         = var.vpc_env
  subnet_cidr_blocks              = {
    public_subnet1                = {
      subnet_cidr_block           = var.subnet1_cidr_block
      availability_zone           = var.availability_zone_1
      ipv6_address                = false
      ip4_address                 = true
      sub_name                    = var.subnet1
    }
    public_subnet2                = {
      subnet_cidr_block           = var.subnet2_cidr_block
      availability_zone           = var.availability_zone_2
      ipv6_address                = false
      ip4_address                 = true
      sub_name                    = var.subnet2
    }
    public_subnet3                = {
      subnet_cidr_block           = var.subnet3_cidr_block
      availability_zone           = var.availability_zone_3
      ipv6_address                = false
      ip4_address                 = true
      sub_name                    = var.subnet3
    }
    private_subnet1               = {
      subnet_cidr_block           = var.subnet4_cidr_block
      availability_zone           = var.availability_zone_1
      ipv6_address                = false
      ip4_address                 = false
      sub_name                    = var.subnet4
    }
    private_subnet2               = {
      subnet_cidr_block           = var.subnet5_cidr_block
      availability_zone           = var.availability_zone_2
      ipv6_address                = false
      ip4_address                 = false
      sub_name                    = var.subnet5
    }
    private_subnet3               = {
      subnet_cidr_block           = var.subnet6_cidr_block
      availability_zone           = var.availability_zone_3
      ipv6_address                = false
      ip4_address                 = false
      sub_name                    = var.subnet6
    }
  }
  db_subnet_group_name            = var.db_subnet_group_name
}

module "security_group" { 
  source                          = "../../modules/SG"
  vpc_id                          = module.vpc.vpc_id
  sg_resources                    = {
    ec2                           = {
      sg_name                     = var.sg-name1
      sg_description              = var.sg-description1
      ingress_rules               = [{
        from_port                 = 80
        to_port                   = 80
        protocol                  = "tcp"
        cidr_blocks               = ["0.0.0.0/0"]
      }]
      egress_rules                = [{
        from_port                 = 0
        to_port                   = 0
        protocol                  = "-1"
        cidr_blocks               = ["0.0.0.0/0"]
      }]
    }
    alb                           = {
      sg_name                     = var.sg-name2
      sg_description              = var.sg-description2
      ingress_rules               = [
        {
          from_port               = 80
          to_port                 = 80
          protocol                = "tcp"
          cidr_blocks             = ["0.0.0.0/0"]
        },
        {
          from_port               = 443
          to_port                 = 443
          protocol                = "tcp"
          cidr_blocks             = ["0.0.0.0/0"]
        }
      ]
      egress_rules                = [{
        from_port                 = 0
        to_port                   = 0
        protocol                  = "-1"
        cidr_blocks               = ["0.0.0.0/0"]
      }]
    }
    rds                           = {
      sg_name                     = var.sg-name3
      sg_description              = var.sg-description3
      ingress_rules               = [{
        from_port                 = 5432
        to_port                   = 5432
        protocol                  = "tcp"
        cidr_blocks               = ["0.0.0.0/0"]
      }]
      egress_rules                = [{
        from_port                 = 0
        to_port                   = 0
        protocol                  = "-1"
        cidr_blocks               = ["0.0.0.0/0"]
      }]
    }
    ecs                           = {
      sg_name                     = var.sg-name4
      sg_description              = var.sg-description4
      ingress_rules               = [{
        from_port                 = 80
        to_port                   = 80
        protocol                  = "tcp"
        cidr_blocks               = ["0.0.0.0/0"]
      }]
      egress_rules                = [{
        from_port                 = 0
        to_port                   = 0
        protocol                  = "-1"
        cidr_blocks               = ["0.0.0.0/0"]
      }]
    }
    ecs-alb                           = {
      sg_name                     = var.sg-name5
      sg_description              = var.sg-description5
      ingress_rules               = [
        {
          from_port               = 80
          to_port                 = 80
          protocol                = "tcp"
          cidr_blocks             = ["0.0.0.0/0"]
        },
        {
          from_port               = 443
          to_port                 = 443
          protocol                = "tcp"
          cidr_blocks             = ["0.0.0.0/0"]
        }
      ]
      egress_rules                = [{
        from_port                 = 0
        to_port                   = 0
        protocol                  = "-1"
        cidr_blocks               = ["0.0.0.0/0"]
      }]
    }
  }
  depends_on                      = [module.vpc]
}

 module "key-pair" {
  source                          = "../../modules/key-pair"
  key_pair_name                   = var.key_pair_name
}
module "IAM" {
  source                          = "../../modules/IAM"
  create_ec2_iam_role             = false
  ec2_iam_role_name               = var.ec2_iam_role_name
  create_ec2_iam_policy           = false
  ec2_iam_policy_name             = var.ec2_iam_policy_name
  create_ecs_iam_role             = true
  ecs_iam_role_name               = var.ecs_iam_role_name
  create_ecs_iam_policy           = true
  ecs_iam_policy_name             = var.ecs_iam_policy_name
}

module "LB" {
  source                          = "../../modules/LB"
  lb_resources                    = {
    resource-1                    = {
      lb_name                         = var.lb_name1
      load_balancer_type              = var.load_balancer_type1
      lb_security_group               = [module.security_group.security_group_id["ecs"]]
      lb_port_number                  = var.lb_port_number1
      lb_target_type                  = var.lb_target_type1
      listener_port                   = var.listener_port1 
      tg_name                         = var.tg_name1
      lb_target_id                    = []   # No target ID needed for ECS Fargate
      tg_port_number                  = var.tg_port_number1
      use_for                         = "ECS"
      name                            = var.name
      env                             = var.env 
    }
  }
  vpc_id                          = module.vpc.vpc_id
  subnet1_id                      = module.vpc.subnet_id["public_subnet1"]
  subnet2_id                      = module.vpc.subnet_id["public_subnet2"]
  subnet3_id                      = module.vpc.subnet_id["public_subnet3"]
  depends_on                      = [module.EC2, module.security_group]
}

module "cloudwatch_logs" {
  source                          = "../../modules/cloudwatch"
  cloudwatch_resources            = {
    "resource-1" = {
      cloudwatch_log_name         = var.cloudwatch_log_name1
      cl_lg_name                  = var.cl_lg_name1
      cl_lg_app                   = var.cl_lg_app1
      cw_lg_stream_name           = var.cw_lg_stream_name1
    }
    "resource-2" = {
      cloudwatch_log_name         = var.cloudwatch_log_name2
      cl_lg_name                  = var.cl_lg_name2
      cl_lg_app                   = var.cl_lg_app2
      cw_lg_stream_name           = var.cw_lg_stream_name2
    }
  }
}

module "ECS" {
  source          = "../../modules/ECS"

  ecs_resources = {
    # Service 1 (with Load Balancer)
    service-1 = {
      ecs_cluster_name                = var.ecs_cluster_name
      name                            = var.ecs-name
      env                             = var.ecs-env
      ecs_task_def_family             = var.ecs_task_def_family
      ecs_task_def_network_mode       = var.ecs_task_def_network_mode
      ecs_task_requires_compatibilities= var.ecs_task_requires_compatibilities
      ecs_os_family                   = var.ecs_os_family
      ecs_cpu_architecture            = var.ecs_cpu_architecture
      ecs_task_def_cpu                = var.ecs_task_def_cpu
      ecs_task_def_memory             = var.ecs_task_def_memory
      ecs_task_def_task_role_arn      = module.IAM.ecs_iam_role_arn
      ecs_task_def_execution_role_arn = module.IAM.ecs_iam_role_arn
      ecs_task_def_container_name     = var.ecs_task_def_container_name
      ecs_container_cpu               = var.ecs-container-cpu
      ecs_container_memory_reservation= var.ecs_container_memory_reservation
      ecs_task_def_container_port     = var.ecs_task_def_container_port
      ecs_task_def_host_port          = var.ecs_task_def_host_port
      ecs_awslogs_group               = module.cloudwatch_logs.cloudwatch_log_group_names["service-1"]
      aws_region                      = var.aws_region
      ecs_service_name                = var.ecs_service_name
      ecs_launch_type                 = var.ecs_launch_type
      ecs_desired_count               = var.ecs_service_desired_count
      ecs_security_group              = [module.security_group.security_group_id["ecs-alb"]]
      ecs_target_group_arn            = module.LB.target_group_arn["service-1"]
      ecs_service_container_name      = var.ecs_task_def_container_name
      ecs_service_container_port      = var.ecs_task_def_container_port
    }

    # Service 2 (without Load Balancer)
    service-2 = {
      ecs_cluster_name                = var.ecs_cluster_name
      name                            = var.ecs-name
      env                             = var.ecs-env
      ecs_task_def_family             = var.ecs_task_def_family_1 
      ecs_task_def_network_mode       = var.ecs_task_def_network_mode
      ecs_task_requires_compatibilities= var.ecs_task_requires_compatibilities
      ecs_os_family                   = var.ecs_os_family
      ecs_cpu_architecture            = var.ecs_cpu_architecture
      ecs_task_def_cpu                = var.ecs-container-cpu_1
      ecs_task_def_memory             = var.ecs_task_def_memory_1
      ecs_task_def_task_role_arn      = module.IAM.ecs_iam_role_arn
      ecs_task_def_execution_role_arn = module.IAM.ecs_iam_role_arn
      ecs_task_def_container_name     = var.ecs_task_def_container_name_1
      ecs_container_cpu               = var.ecs_container_cpu_1
      ecs_container_memory_reservation= var.ecs_container_memory_reservation_1
      ecs_task_def_container_port     = null
      ecs_task_def_host_port          = null
      ecs_awslogs_group               = module.cloudwatch_logs.cloudwatch_log_group_names["service-2"]
      aws_region                      = var.aws_region
      ecs_service_name                = var.ecs_service_name_1
      ecs_launch_type                 = var.ecs_launch_type
      ecs_desired_count               = 1
      ecs_security_group              = [module.security_group.security_group_id["ecs-no-lb"]]
      ecs_target_group_arn            = ""  # No load balancer for this service
      ecs_service_container_name      = "new"
      ecs_service_container_port      = null
    }
  }

  subnet1_id        = module.vpc.subnet_id["public_subnet1"]
  subnet2_id        = module.vpc.subnet_id["public_subnet2"]
  subnet3_id        = module.vpc.subnet_id["public_subnet3"]
  ecs_asg_max_size  = var.ecs_asg_max_size
  ecs_asg_min_size  = var.ecs_asg_min_size
  depends_on        = [module.cloudwatch_logs, module.IAM, module.security_group]
}