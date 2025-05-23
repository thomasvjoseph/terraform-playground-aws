output "cluster_engine" {
  value = aws_elasticache_cluster.cache.engine
}

output "arn" {
  value = aws_elasticache_cluster.cache.arn
}


output "subnet_group_name" {
  value = aws_elasticache_subnet_group.cache_group.name
}