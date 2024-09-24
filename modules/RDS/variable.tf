variable "parameter_group" {
  type        = string
}
  
variable "parameter_group_family" {
  type        = string  
}

variable "parameter_group_description" {
  type        = string
}

variable "rds_parameters" {
  type = map(object({
    rds_parameter_name = string
    rds_parameter_value = string
  }))
}

variable "rds-name" {
  type        = string
}

variable "rds_engine" {
  type        = string
  description = "Database engine type"
}

variable "rds-identifier" {
  type        = string
  description = "Name of database inside storage engine"
}

variable "rds-env" {
  type        = string
  description = "Name of environment this VPC is targeting"
}

variable "allocated_storage" {
  type        = number
  description = "Storage allocated to database instance"
}

variable "max_allocated_storage" {
  type        = number
  description = "storage auto scaling"
}

variable "engine_version" {
  type        = string
  description = "Database engine version"
}

variable "db_instance_type" {
  type        = string
  description = "Instance type for database instance"
}

variable "storage_type" {
  type        = string
  description = "Type of underlying storage for database"
}

/* variable "iops" {
  type        = number
  description = "The amount of provisioned IOPS"
} */

variable "database_name" {
  type        = string
  description = "Name of database inside storage engine"
}

variable "database_username" {
  type        = string
  description = "Name of user inside storage engine"
}

variable "database_password" {
  type        = string
  description = "Database password inside storage engine"
}

variable "database_port" {
  type        = number
  description = "Port on which database will accept connections"
}
variable "availability_zone" {
  type = string
  description = "Availability zone for database instance"
}

variable "vpc_security_group_id_rds" {
  type = list
  description = "List of security groups for database instance"
}

variable "backup_retention_period" {
  type        = number
  description = "Number of days to keep database backups"
}

variable "backup_window" {
  type        = string
  description = "30 minute time window to reserve for backups"
}

variable "maintenance_window" {
  type        = string
  description = "60 minute time window to reserve for maintenance"
}

variable "auto_minor_version_upgrade" {
  type        = bool
  description = "Minor engine upgrades are applied automatically to the DB instance during the maintenance window"
}

variable "final_snapshot_identifier" {
  type        = string
  description = "Identifier for final snapshot if skip_final_snapshot is set to false"
}

variable "skip_final_snapshot" {
  type        = bool
  description = "Flag to enable or disable a snapshot if the database instance is terminated"
}

variable "copy_tags_to_snapshot" {
  type        = bool
  description = "Flag to enable or disable copying instance tags to the final snapshot"
}

variable "multi_availability_zone" {
  type        = bool
  description = "Flag to enable hot standby in another availability zone"
}

/* variable "storage_throughput" {
  type        = number
  description = "The amount of provisioned throughput for the DB instance"
} */

variable "storage_encrypted" {
  type        = bool
  description = "Flag to enable storage encryption"
}

variable "monitoring_interval" {
  type        = number
  description = "The interval, in seconds, between points when Enhanced Monitoring metrics are collected"
}

variable "deletion_protection" {
  type        = bool
  description = "Flag to protect the database instance from deletion"
}

variable "publicly_accessible" {
    type = bool
    description = "value for publicly_accessible"
}

variable "db_subnet_group_name" {
  type = string
}

variable "performance_insight_enabled" {
  type = bool
}

variable "tags" {
  default     = {}
  type        = map(string)
  description = "Extra tags to attach to the RDS resources"
}