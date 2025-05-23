variable "cluster_id" {
  type        = string
  description = "Name of the ElastiCache"
}

variable "cluster_engine" {
  type        = string
  description = "ElastiCache Engine Type"
}

variable "node_type" {
  type        = string
  description = "Cache Node Type"
}

variable "number_cache_node" {
  type        = number
  description = "Number of Cache Nodes"
}

variable "parameter_group_name" {
  type        = string
  description = "Parameter Group Name"
}

variable "engine_version" {
  type        = string
  description = "ElastiCache Engine Version"
}

variable "port" {
  type        = number
  description = "Cache Port"
}

variable "maintenance_window" {
  type        = string
  description = "Maintenance Window"
  default     = "sun:05:00-sun:09:00"
}

variable "tags" {
  type        = map(any)
  description = "Tag value for Redis Cache"
}

variable "subnet_group_name" {
  type        = string
  description = "Subnet Group Name"
}

variable "subnets" {
  type        = list(string)
  description = "List of subnet IDs"
}

variable "security_group_ids" {
  type        = list(string)
  description = "List of Security Group IDs"
}