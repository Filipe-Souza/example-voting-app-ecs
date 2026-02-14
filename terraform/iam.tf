resource "aws_iam_role" "ecs_task_def_execution_role" {
  name               = local.ecs.task_def_exec_iam_role_name
  assume_role_policy = data.aws_iam_policy_document.ecs_task_def_assume_role_policy.json
}

data "aws_iam_policy_document" "ecs_task_def_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecs_task_def_execution_role_policy" {
  role       = aws_iam_role.ecs_task_def_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

