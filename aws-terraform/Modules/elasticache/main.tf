# AWS ElastiCache Module

resource "aws_elasticache_subnet_group" "this" {
  name       = "${var.cluster_name}-subnet-group"
  subnet_ids = var.subnet_ids

  tags = var.tags
}

resource "aws_elasticache_cluster" "this" {
  cluster_id               = var.cluster_name
  engine                   = var.engine
  engine_version           = var.engine_version
  node_type                = var.node_type
  num_cache_nodes          = var.num_cache_nodes
  port                     = var.port
  subnet_group_name        = aws_elasticache_subnet_group.this.name
  security_group_ids       = var.security_group_ids
  parameter_group_name     = var.parameter_group_name
  snapshot_retention_limit = var.snapshot_retention_limit

  tags = merge(var.tags, {
    Name = var.cluster_name
  })
}
