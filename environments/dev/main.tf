
data "aws_iam_role" "ecs_iam_task_role" {
  name = "ecs-iam"
}

data "aws_iam_role" "ec2_iam_role" {
  name = "ec2-iam"
}

data "aws_iam_instance_profile" "ec2_iam_instance_profile" {
  name = "ec2-iam-profile"
}

resource "aws_resourcegroups_group" "test-qa" {
  name = "Test-QA"
  resource_query {
    type = "TAG_FILTERS_1_0"
    query = jsonencode({
      ResourceTypeFilters = ["AWS::AllSupported"],
      TagFilters = [
        {
          Key    = "Environment"
          Values = ["QA"]
        },
        {
          Key    = "Project"
          Values = ["Test"]
        }
      ]
    })
  }
  tags = {
    Environment = "QA"
    Project     = "Test"
    Service     = "ResourceGroup"
  }
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "Test-VPC-QA"
  cidr = "172.16.0.0/19"

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["172.16.0.0/24", "172.16.1.0/24", "172.16.2.0/24"]
  public_subnets  = ["172.16.10.0/24", "172.16.11.0/24", "172.16.12.0/24"]

  enable_nat_gateway = false
  single_nat_gateway = false
  enable_vpn_gateway = false

  tags = {
    Environment = "QA"
    Project     = "Test"
    Service     = "VPC"
  }
}

module "security_group" {
  source = "../../Modules/SG"
  vpc_id = module.vpc.vpc_id

  sg_resources = {
    Test-Node-V1-SG = {
      sg_name        = "Test-Node-ALB-V1-SG"
      sg_description = "ALB Security Group for Node V1"
      ingress_rules = [
        {
          from_port   = 80
          to_port     = 80
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        },
        {
          from_port   = 81
          to_port     = 81
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        },
        {
          from_port   = 443
          to_port     = 443
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        }
      ]
      egress_rules = [{
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
      }]
      tags = {
        Name        = "Test-Node-V1-SG"
        Environment = "QA"
        UsedFor     = "ECS Node v1"
        Role        = "ALB"
        Project     = "Test"
      }
    }

    Test-Node-V1 = {
      sg_name        = "Test-Node-V1"
      sg_description = "Backend Node V1 Security Group"
      ingress_rules = [
        {
          from_port   = 80
          to_port     = 80
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        },

      ]
      egress_rules = [{
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
      }]
      tags = {
        Name        = "Test-Node-V1"
        Environment = "QA"
        UsedFor     = "ECS Node v1 Backend"
        Role        = "Backend"
        Project     = "Test"
      }
    }

    Test-Node-V2 = {
      sg_name        = "Test-Node-V2"
      sg_description = "Backend Node V2 Security Group"
      ingress_rules = [
        {
          from_port   = 80
          to_port     = 80
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        }
      ]
      egress_rules = [{
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
      }]
      tags = {
        Name        = "Test-Node-V2"
        Environment = "QA"
        UsedFor     = "ECS Node v2 Backend"
        Role        = "Backend"
        Project     = "Test"
      }
    }

    Test-Redis-SG = {
      sg_name        = "Test-Redis-SG"
      sg_description = "Redis Security Group"
      ingress_rules = [
        {
          from_port   = 6379
          to_port     = 6379
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        },
        {
          from_port   = 6378
          to_port     = 6378
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        },
        {
          from_port   = 22
          to_port     = 22
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        }
      ]
      egress_rules = [{
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
      }]
      tags = {
        Name        = "Test-Redis-SG"
        Environment = "QA"
        UsedFor     = "Redis EC2 Instances"
        Role        = "Redis"
        Project     = "Test"
      }
    }

    Test-Postgres-SG = {
      sg_name        = "Test-Postgres-SG"
      sg_description = "Postgres Security Group"
      ingress_rules = [
        {
          from_port   = 5432
          to_port     = 5432
          protocol    = "tcp"
          cidr_blocks = [module.vpc.vpc_cidr_block] # Restrict to VPC only
        },
        {
          from_port   = 22
          to_port     = 22
          protocol    = "tcp"
          cidr_blocks = [module.vpc.vpc_cidr_block] # Restrict to VPC only for emergency access
        }
      ]
      egress_rules = [{
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
      }]
      tags = {
        Name        = "Test-Postgres-SG"
        Environment = "QA"
        UsedFor     = "PostgreSQL Database"
        Role        = "Postgres"
        Project     = "Test"
      }
    }
  }
}

module "alb" {
  source = "../../Modules/ALB"
  vpc_id = module.vpc.vpc_id

  lb_resources = {
    main = {
      lb_name                    = "Test-ALB-QA"
      subnets                    = module.vpc.public_subnets
      lb_security_group          = [module.security_group.security_group_id["Test-Node-V1-SG"]]
      lb_target_type             = "ip"
      internal                   = false
      tg_name                    = "default-tg"
      tg_port_number             = 80
      lb_port_number             = 80
      lb_target_id               = []
      load_balancer_type         = "application"
      enable_deletion_protection = false
      tags = {
        Environment = "QA"
        Project     = "Test"
      }
      use_for = "ECS"
    }
  }

  lb_target_groups = {
    nodev1 = {
      lb_key          = "main"
      tg_name         = "test-nodev1-tg"
      tg_port_number  = 80
      tg_path_pattern = ["/api/*"]
      priority        = 10
      use_for         = "ECS"
      lb_target_id    = []
      tags = {
        Service     = "api"
        Environment = "QA"
        Project     = "Test"
      }
    }

    nodev2 = {
      lb_key          = "main"
      tg_name         = "test-nodev2-tg"
      tg_port_number  = 81
      tg_path_pattern = ["/*"]
      priority        = 20
      use_for         = "ECS"
      lb_target_id    = []
      tags = {
        Service     = "web"
        Environment = "QA"
        Project     = "Test"
      }
    }
  }
  depends_on = [module.vpc, module.security_group]
}
module "ECR-Nodev1" {
  source               = "../../Modules/ECR"
  app                  = "test-nodev1"
  image_tag_mutability = "IMMUTABLE"
  tags = {
    Environment = "QA"
    Name        = "test-nodev1"
    Project     = "Test"
  }
}

module "ECR-Nodev2" {
  source               = "../../Modules/ECR"
  app                  = "test-nodev2"
  image_tag_mutability = "IMMUTABLE"
  tags = {
    Environment = "QA"
    Name        = "test-nodev2"
    Project     = "Test"
  }
}

module "cloudwatch_logs" {
  source = "../../Modules/CloudWatchLogs"
  cloudwatch_resources = {
    /* "resource-1" = {
      cloudwatch_log_name = "EC2/EC2-Agent/Postgres-Server-Logs"
      cl_lg_name          = "EC2"
      cl_lg_app           = "Postgres-Server-Logs"
      cw_lg_stream_name   = "Test-Node-V1-BE"
      tags = {
        Environment = "QA"
        Name        = "EC2-Test-Node-V1-LogGroup"
        Project     = "Test"
      }
    } */
    "resource-1" = {
      cloudwatch_log_name = "ECS/Test-Node-v1-Logs"
      cl_lg_name          = "ECS"
      cl_lg_app           = "Test-Node-v1-Logs"
      cw_lg_stream_name   = "Test-Node-v1-Stream"
      tags = {
        Environment = "QA"
        Name        = "ECS-Test-Node-v1-LogGroup"
        Project     = "Test"
      }
    }
    "resource-2" = {
      cloudwatch_log_name = "ECS/Test-Node-v2-Logs"
      cl_lg_name          = "ECS"
      cl_lg_app           = "Test-Node-v2-Logs"
      cw_lg_stream_name   = "Test-Node-v2-Stream"
      tags = {
        Environment = "QA"
        Name        = "ECS-Test-Node-v2-LogGroup"
        Project     = "Test"
      }
    }
  }
}

module "ecs" {
  source = "../../Modules/ECS"

  ecs_resources = {
    Nodev1 = {
      ecs_cluster_name                  = "Test-Node-v1-cluster"
      ecs_task_def_family               = "Test-Node-v1-Task-Definition"
      ecs_task_def_network_mode         = "awsvpc"
      ecs_task_requires_compatibilities = ["FARGATE"]
      ecs_os_family                     = "LINUX"
      ecs_cpu_architecture              = "X86_64"
      ecs_task_def_cpu                  = 2048
      ecs_task_def_memory               = 4096
      ecs_task_def_task_role_arn        = data.aws_iam_role.ecs_iam_task_role.arn
      ecs_task_def_execution_role_arn   = data.aws_iam_role.ecs_iam_task_role.arn
      ecs_task_def_container_name       = "test-node-v1-container"
      ecs_task_def_container_port       = 80
      ecs_task_def_host_port            = 80
      ecs_image_url                     = "nginx:latest"
      ecs_container_cpu                 = 2048
      ecs_container_memory_reservation  = 4096
      ecs_awslogs_group                 = module.cloudwatch_logs.cloudwatch_log_group_names["resource-1"]
      aws_region                        = "us-east-1"
      ecs_service_name                  = "Test-Node-v1-Service"
      ecs_launch_type                   = "FARGATE"
      ecs_desired_count                 = 1
      ecs_security_group                = [module.security_group.security_group_id["Test-Node-V1"]]
      ecs_target_group_arn              = module.alb.target_group_arn["nodev1"]
      ecs_service_container_name        = "test-node-v1-container"
      ecs_service_container_port        = 80
    },
    Nodev2 = {
      ecs_cluster_name                  = "Test-Node-v2-cluster"
      ecs_task_def_family               = "Test-Node-v2-Task-Definition"
      ecs_task_def_network_mode         = "awsvpc"
      ecs_task_requires_compatibilities = ["FARGATE"]
      ecs_os_family                     = "LINUX"
      ecs_cpu_architecture              = "X86_64"
      ecs_task_def_cpu                  = 2048
      ecs_task_def_memory               = 4096
      ecs_task_def_task_role_arn        = data.aws_iam_role.ecs_iam_task_role.arn
      ecs_task_def_execution_role_arn   = data.aws_iam_role.ecs_iam_task_role.arn
      ecs_task_def_container_name       = "test-node-v2-container"
      ecs_task_def_container_port       = 80
      ecs_task_def_host_port            = 80
      ecs_image_url                     = "nginx:latest"
      ecs_container_cpu                 = 2048
      ecs_container_memory_reservation  = 4096
      ecs_awslogs_group                 = module.cloudwatch_logs.cloudwatch_log_group_names["resource-2"]
      aws_region                        = "us-east-1"
      ecs_service_name                  = "Test-Node-v2-Service"
      ecs_launch_type                   = "FARGATE"
      ecs_desired_count                 = 1
      ecs_security_group                = [module.security_group.security_group_id["Test-Node-V2"]]
      ecs_target_group_arn              = module.alb.target_group_arn["nodev2"]
      ecs_service_container_name        = "test-node-v2-container"
      ecs_service_container_port        = 80
    }
  }



  subnets          = [module.vpc.public_subnets[0], module.vpc.public_subnets[1]]
  ecs_asg_max_size = 2
  ecs_asg_min_size = 1


  tags = {
    Environment = "QA"
    Project     = "Test"
    Service     = "ECS"
  }
  depends_on = [module.vpc, module.alb, module.cloudwatch_logs]
}

module "keypair" {
  source        = "thomasvjoseph/keypair/aws"
  version       = "1.1.2"
  key_pair_name = "test-instance-key-qa"
}

module "EC2" {
  source = "../../Modules/EC2"

  ec2_resources = {
    redis1 = {
      ami_id              = "ami-0360c520857e3138f"
      instance_type       = "t3.micro"
      subnet_id           = module.vpc.public_subnets[0]
      security_group_ids  = [module.security_group.security_group_id["Test-Redis-SG"]]
      availability_zone   = module.vpc.azs[0]
      associate_public_ip = true
      use_ebs_block       = false
      ebs_size            = 0
      enable_iam_profile  = false # Changed to true - required for CloudWatch Agent
      # user_data = templatefile("${path.module}/Scripts/cloudwatch_user_data.sh.tpl", {
      #   device_name = "/dev/xvdf"
      #   mount_point = "/mnt/data"
      #   log_group   = module.cloudwatch_logs.cloudwatch_log_group_names["resource-1"]
      # })

      tags = {
        Name        = "Test-Redis-QA-BullMQ"
        Environment = "QA"
        Terraform   = "true"
        UsedFor     = "Redis BullMQ"
        Project     = "Test"
      }
    }
    redis2 = {
      ami_id              = "ami-0360c520857e3138f"
      instance_type       = "t3.micro"
      subnet_id           = module.vpc.public_subnets[1]
      security_group_ids  = [module.security_group.security_group_id["Test-Redis-SG"]]
      availability_zone   = module.vpc.azs[1]
      associate_public_ip = true
      ebs_size            = 0
      enable_iam_profile  = false

      tags = {
        Name        = "Test-Redis-QA-Cache"
        Environment = "QA"
        Terraform   = "true"
        UsedFor     = "Redis Cache"
        Project     = "Test"
      }
    }
    postgres1 = {
      ami_id              = "ami-0360c520857e3138f"
      instance_type       = "t3.micro"
      subnet_id           = module.vpc.public_subnets[1]
      security_group_ids  = [module.security_group.security_group_id["Test-Postgres-SG"]]
      availability_zone   = module.vpc.azs[1]
      associate_public_ip = true
      use_ebs_block       = true
      ebs_size            = 40
      enable_iam_profile  = false

      tags = {
        Name        = "Test-Postgres-QA"
        Environment = "QA"
        Terraform   = "true"
        UsedFor     = "PostgreSQL Database"
        Project     = "Test"
      }
    }
  }

  root_volume_size      = 10
  ebs_device_name       = "/dev/xvdf"
  ebs_volume_type       = "gp3" # gp3 is newer and more cost-effective than gp2
  delete_on_termination = true
  encrypted             = true
  key_pair_name         = module.keypair.key_pair_name

  ec2_iam_role         = data.aws_iam_role.ec2_iam_role.name
  iam_instance_profile = data.aws_iam_instance_profile.ec2_iam_instance_profile.name

  depends_on = [module.vpc, module.keypair, module.cloudwatch_logs]
}

module "s3_cloudfront" {
  source  = "thomasvjoseph/s3_cloudfront/aws"
  version = "1.1.4"
  s3_bucket_name = "test-s3-admin-bucket-qa"
  cloudfront_description = "test-admin-qa-dashboard"
  tags = {
    Environment = "QA"
    Project     = "Test"
    Service     = "S3-CloudFront"
  }
}

/* module "vpc_endpoints" {
  source             = "../../Modules/VPC-EndPoints"
  vpc_id             = module.vpc.vpc_id
  subnet_ids         = module.vpc.private_subnets
  route_table_ids    = module.vpc.private_route_table_ids
  security_group_ids = [module.security_group.security_group_id["VPC-Endpoint-SG"]] # Use dedicated SG
  aws_region         = "us-east-1"
  environment        = "QA"

  create_ssm_endpoint             = false
  create_ssmmessages_endpoint     = false
  create_ec2messages_endpoint     = false
  create_cloudwatch_logs_endpoint = false # Enable for Session Manager logging
  create_ecr_api_endpoint         = false
  create_ecr_dkr_endpoint         = false
  create_s3_gateway_endpoint      = true
}

# CloudWatch Dashboard Configuration
module "cloudwatch_dashboard" {
  source = "../../Modules/CloudWatchDashboard"

  dashboard_name_prefix = "Test"
  environment           = "QA"
  region                = "us-east-1" # Update to your region

  # EC2 Configuration
  enable_ec2_dashboard = true
  ec2_instances        = module.EC2.instances_for_monitoring

  widget_width  = 12
  widget_height = 6

  depends_on = [module.EC2]
} */
