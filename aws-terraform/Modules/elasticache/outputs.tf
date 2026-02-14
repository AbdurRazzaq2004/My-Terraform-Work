output "cluster_id" {
  description = "ID of the ElastiCache cluster"
  value       = aws_elasticache_cluster.this.cluster_id
}

output "cache_nodes" {
  description = "List of cache node details"
  value       = aws_elasticache_cluster.this.cache_nodes
}

output "cluster_address" {
  description = "DNS name of the cluster (Memcached only)"
  value       = aws_elasticache_cluster.this.cluster_address
}

output "configuration_endpoint" {
  description = "Configuration endpoint (Memcached only)"
  value       = aws_elasticache_cluster.this.configuration_endpoint
}
