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
  value = aws_elasticache_cluster.aws_redis.cache_nodes[0].address
}

output "url_ecr_repo" {
  value = aws_ecr_repository.ecr_repo.repository_url
}
output "ecs_cluster_name" {
  value = aws_ecs_cluster.voting_app_cluster.name
}

output "ecs_services_names" {
  value = {
    vote: aws_ecs_service.ecs_service_vote.name,
    worker: aws_ecs_service.ecs_service_worker.name,
    result: aws_ecs_service.ecs_service_result.name
  }
}

output "ecs_tasks_family" {
  value = {
    vote: "${terraform.workspace}_vote_task"
    result: "${terraform.workspace}_result_task"
    worker: "${terraform.workspace}_worker_task"
  }
}
