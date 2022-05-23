resource "aws_ecs_task_definition" "task_def_vote" {
  family                   = "${terraform.workspace}_vote_task"
  execution_role_arn       = aws_ssm_parameter.ecs_task_exec_iam_role.value
  task_role_arn            = aws_ssm_parameter.ecs_task_exec_iam_role.value
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = local.ecs.task_def_size.cpu
  memory                   = local.ecs.task_def_size.memory
  container_definitions    = data.template_file.task_def_vote_template.rendered
}

resource "aws_ecs_task_definition" "task_def_result" {
  family                   = "${terraform.workspace}_result_task"
  execution_role_arn       = aws_ssm_parameter.ecs_task_exec_iam_role.value
  task_role_arn            = aws_ssm_parameter.ecs_task_exec_iam_role.value
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = local.ecs.task_def_size.cpu
  memory                   = local.ecs.task_def_size.memory
  container_definitions    = data.template_file.task_def_result_template.rendered
}

resource "aws_ecs_task_definition" "task_def_worker" {
  family                   = "${terraform.workspace}_worker_task"
  execution_role_arn       = aws_ssm_parameter.ecs_task_exec_iam_role.value
  task_role_arn            = aws_ssm_parameter.ecs_task_exec_iam_role.value
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = local.ecs.task_def_size.cpu
  memory                   = local.ecs.task_def_size.memory
  container_definitions    = data.template_file.task_def_worker_template.rendered
}
