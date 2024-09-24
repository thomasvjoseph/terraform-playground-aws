resource "aws_ecs_cluster" "ecs_cluster" {
  for_each = var.ecs_resources
  name     = each.value.ecs_cluster_name
  tags = {
    "Name"      = each.value.name
    "Env"       = each.value.env
    "terraform" = "true"
  }
}

resource "aws_ecs_task_definition" "ecs_task_definition" {
  for_each                 = var.ecs_resources
  family                   = each.value.ecs_task_def_family
  network_mode             = each.value.ecs_task_def_network_mode
  requires_compatibilities = each.value.ecs_task_requires_compatibilities
  runtime_platform {
    operating_system_family = each.value.ecs_os_family
    cpu_architecture        = each.value.ecs_cpu_architecture
  }
  cpu                   = each.value.ecs_task_def_cpu
  memory                = each.value.ecs_task_def_memory
  task_role_arn         = each.value.ecs_task_def_task_role_arn
  execution_role_arn    = each.value.ecs_task_def_execution_role_arn
  container_definitions = jsonencode([
    {
      name                = each.value.ecs_task_def_container_name
      #image               = "${each.value.ecs_image_url}:latest"
      image               = "nginx:1.23.1"
      cpu                 = each.value.ecs_container_cpu
      memoryReservation   = each.value.ecs_container_memory_reservation
      essential           = true
      portMappings        = each.value.ecs_task_def_container_port != null ? [
        {
          containerPort = each.value.ecs_task_def_container_port
          hostPort      = each.value.ecs_task_def_host_port
        }
      ] : []
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = each.value.ecs_awslogs_group
          awslogs-region        = each.value.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
  skip_destroy = true
  tags = {
    "Name"      = each.value.name
    "Env"       = each.value.env
    "terraform" = "true"
  }
}

resource "aws_ecs_service" "ecs_service" {
  for_each          = var.ecs_resources
  name              = each.value.ecs_service_name
  cluster           = aws_ecs_cluster.ecs_cluster[each.key].id
  launch_type       = each.value.ecs_launch_type
  task_definition   = aws_ecs_task_definition.ecs_task_definition[each.key].arn
  desired_count     = each.value.ecs_desired_count

  network_configuration {
    subnets         = [var.subnet1_id, var.subnet2_id, var.subnet3_id]
    security_groups = each.value.ecs_security_group
    assign_public_ip = true
  }

  dynamic "load_balancer" {
    for_each = each.value.ecs_target_group_arn != null ? [each.value.ecs_target_group_arn] : []
      content {
        target_group_arn = each.value.ecs_target_group_arn
        container_name   = each.value.ecs_service_container_name
        container_port   = each.value.ecs_service_container_port
      }
  }

  lifecycle {
    ignore_changes = [desired_count]
  }

  enable_ecs_managed_tags = true
  enable_execute_command  = true
  tags = {
    "Name"      = each.value.name
    "Env"       = each.value.env
    "terraform" = "true"
  }
}

resource "aws_appautoscaling_target" "ecs_target" {
  for_each            = var.ecs_resources
  max_capacity        = var.ecs_asg_max_size
  min_capacity        = var.ecs_asg_min_size
  resource_id         = "service/${aws_ecs_cluster.ecs_cluster[each.key].name}/${aws_ecs_service.ecs_service[each.key].name}"
  scalable_dimension  = "ecs:service:DesiredCount"
  service_namespace   = "ecs"
}

resource "aws_appautoscaling_policy" "ecs_policy_memory" {
  for_each                               = var.ecs_resources
  name                                   = "memory-autoscaling-${each.key}"
  policy_type                            = "TargetTrackingScaling"
  resource_id                            = aws_appautoscaling_target.ecs_target[each.key].resource_id
  scalable_dimension                     = aws_appautoscaling_target.ecs_target[each.key].scalable_dimension
  service_namespace                      = aws_appautoscaling_target.ecs_target[each.key].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
    target_value = 85
  }
}

resource "aws_appautoscaling_policy" "ecs_policy_cpu" {
  for_each                               = var.ecs_resources
  name                                   = "cpu-autoscaling-${each.key}"
  policy_type                            = "TargetTrackingScaling"
  resource_id                            = aws_appautoscaling_target.ecs_target[each.key].resource_id
  scalable_dimension                     = aws_appautoscaling_target.ecs_target[each.key].scalable_dimension
  service_namespace                      = aws_appautoscaling_target.ecs_target[each.key].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value = 70
  }
}