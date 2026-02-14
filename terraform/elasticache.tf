resource "aws_elasticache_cluster" "aws_redis" {
  cluster_id               = local.project_name
  engine                   = "redis"
  node_type                = "cache.t4g.micro"
  num_cache_nodes          = 1
  engine_version           = "7.0"
  port                     = 6379
  apply_immediately        = true
  maintenance_window       = "sun:05:00-sun:09:00"
  snapshot_window          = "02:00-04:00"
  snapshot_retention_limit = 7
  security_group_ids       = [aws_security_group.databases_sg.id]
  parameter_group_name     = aws_elasticache_parameter_group.default.name
  subnet_group_name        = aws_elasticache_subnet_group.cache_subnet_group.name

}

resource "aws_elasticache_subnet_group" "cache_subnet_group" {
  name       = "${terraform.workspace}-cache-subnet"
  subnet_ids = [for s in data.aws_subnets.default_subnets.ids : s]
}

resource "aws_elasticache_parameter_group" "default" {
  name   = local.project_name
  family = "redis7"
}
