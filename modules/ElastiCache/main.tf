resource "aws_elasticache_cluster" "cache" {
  cluster_id                 = var.cluster_id
  engine                     = var.cluster_engine
  node_type                  = var.node_type
  num_cache_nodes            = var.number_cache_node
  
  parameter_group_name       = var.parameter_group_name
  engine_version             = var.engine_version
  port                       = var.port
  subnet_group_name          = aws_elasticache_subnet_group.cache_group.name
  auto_minor_version_upgrade = true
  security_group_ids         = var.security_group_ids
  maintenance_window         = var.maintenance_window
  tags                       = var.tags
  depends_on                 = [aws_elasticache_subnet_group.cache_group]
}

resource "aws_elasticache_subnet_group" "cache_group" {
  name       = var.subnet_group_name
  subnet_ids = var.subnets
}