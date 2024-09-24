#use RDS parameter group for postgresql
resource "aws_db_parameter_group" "parameter_group" {
  name                           = var.parameter_group
  family                         = var.parameter_group_family
  description                    = var.parameter_group_description

  dynamic "parameter" {
    for_each                     = var.rds_parameters
      content {
        name                     = parameter.value.rds_parameter_name
        value                    = parameter.value.rds_parameter_value
     }
  }
 
  lifecycle {
    create_before_destroy        = true
  }

  tags = {
    "Name"        = var.rds-name
    "Env"         = var.rds-env
    "terraform"   = "true"
  }
}

resource "aws_db_instance" "rds_instance" {
  engine                          = var.rds_engine
  engine_version                  = var.engine_version
  identifier                      = var.rds-identifier
  instance_class                  = var.db_instance_type
  storage_type                    = var.storage_type
  #iops                            = var.iops
  db_name                         = var.database_name
  password                        = var.database_password
  username                        = var.database_username
  backup_retention_period         = var.backup_retention_period
  backup_window                   = var.backup_window
  maintenance_window              = var.maintenance_window
  auto_minor_version_upgrade      = var.auto_minor_version_upgrade
  final_snapshot_identifier       = var.final_snapshot_identifier
  skip_final_snapshot             = var.skip_final_snapshot
  copy_tags_to_snapshot           = var.copy_tags_to_snapshot
  availability_zone               = var.availability_zone
  multi_az                        = var.multi_availability_zone
  vpc_security_group_ids          = var.vpc_security_group_id_rds 
  ca_cert_identifier              = "rds-ca-rsa2048-g1"
  #storage_throughput              = var.storage_throughput
  publicly_accessible             = var.publicly_accessible
  allocated_storage               = var.allocated_storage
  max_allocated_storage           = var.max_allocated_storage
  storage_encrypted               = var.storage_encrypted
  deletion_protection             = var.deletion_protection
  db_subnet_group_name            = var.db_subnet_group_name
  parameter_group_name            = aws_db_parameter_group.parameter_group.name
  performance_insights_enabled    = var.performance_insight_enabled  
  apply_immediately               = true
  tags = {
    "Name"          = var.rds-name
    "Env"           = var.rds-env
    "terraform"     = "true"
  }
}