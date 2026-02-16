resource "aws_ssm_parameter" "rds_db_password" {
  name        = "/voting-app/database-password"
  description = "PostgreSQL database password"
  type        = "SecureString"
  value       = random_password.rds_db_password.result

  tags = local.default_tags
}

resource "aws_ssm_parameter" "rds_db_username" {
  name        = "/voting-app/database-username"
  description = "PostgreSQL database username"
  type        = "SecureString"
  value       = var.database_username

  tags = local.default_tags
}

resource "aws_ssm_parameter" "ecs_task_exec_iam_role" {
  name        = "/voting-app/ecs_task_exec_iam_role"
  description = "ECS Task execution role ARN"
  type        = "SecureString"
  value       = aws_iam_role.ecs_task_def_execution_role.arn

  tags = local.default_tags
}

resource "aws_ssm_parameter" "ecs_task_result_db_string" {
  name = "/voting-app/ecs_task_result_db_string"
  type = "SecureString"
  value = "postgres://${aws_ssm_parameter.rds_db_username.value}:${aws_ssm_parameter.rds_db_password.value}@${aws_db_instance.persistant_database.address}:${aws_db_instance.persistant_database.port}/dbname?sslmode=disable"

  tags = local.default_tags
}

resource "aws_ssm_parameter" "ecs_task_vote_redis_host" {
  name = "/voting-app/ecs_task_vote_redis_host"
  type = "SecureString"
  value = aws_elasticache_cluster.aws_redis.cluster_address

  tags = local.default_tags
}