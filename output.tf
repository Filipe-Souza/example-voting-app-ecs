output "url_vote_app" {
  value = aws_alb.elb_vote.dns_name
}

output "url_result_app" {
  value = aws_alb.elb_result.dns_name
}

output "url_postgres" {
  value = aws_db_instance.persistant_database.address
}

output "url_redis" {
  value = aws_elasticache_cluster.aws_redis.cache_nodes.0.address
}

output "url_ecr_repo" {
  value = aws_ecr_repository.ecr_repo.repository_url
}
