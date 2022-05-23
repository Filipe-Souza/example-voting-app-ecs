resource "aws_ecs_service" "ecs_service_vote" {
  name                   = local.ecs.services_names.vote
  task_definition        = aws_ecs_task_definition.task_def_vote.arn
  cluster                = aws_ecs_cluster.voting_app_cluster.id
  desired_count          = 1
  enable_execute_command = true

  capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    weight            = 1
    base              = 0
  }

  capacity_provider_strategy {
    capacity_provider = "FARGATE"
    weight            = 3
    base              = 3

  }

  network_configuration {
    subnets          = [for s in data.aws_subnets.default_subnets.ids : s]
    security_groups  = [aws_security_group.main_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.elb_vote_tg.arn
    container_name   = "vote_app"
    container_port   = "5000"
  }
}


resource "aws_ecs_service" "ecs_service_result" {
  name                   = local.ecs.services_names.result
  task_definition        = aws_ecs_task_definition.task_def_result.arn
  cluster                = aws_ecs_cluster.voting_app_cluster.id
  desired_count          = 1
  enable_execute_command = true

  capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    weight            = 1
    base              = 0
  }

  capacity_provider_strategy {
    capacity_provider = "FARGATE"
    weight            = 3
    base              = 3

  }

  network_configuration {
    subnets          = [for s in data.aws_subnets.default_subnets.ids : s]
    security_groups  = [aws_security_group.main_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.elb_result_tg.arn
    container_name   = "result_app"
    container_port   = "5001"
  }
}

resource "aws_ecs_service" "ecs_service_worker" {
  name                   = local.ecs.services_names.worker
  task_definition        = aws_ecs_task_definition.task_def_worker.arn
  cluster                = aws_ecs_cluster.voting_app_cluster.id
  desired_count          = 1
  enable_execute_command = true

  capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    weight            = 1
    base              = 0
  }

  capacity_provider_strategy {
    capacity_provider = "FARGATE"
    weight            = 3
    base              = 3

  }

  network_configuration {
    subnets          = [for s in data.aws_subnets.default_subnets.ids : s]
    security_groups  = [aws_security_group.main_sg.id]
    assign_public_ip = true
  }
}
