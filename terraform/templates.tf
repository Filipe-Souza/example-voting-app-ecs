data "template_file" "task_def_vote_template" {
  template = <<EOF
[
  {
    "name": "vote_app",
    "image": "${aws_ecr_repository.ecr_repo.repository_url}:vote",
    "cpu" : ${local.ecs.task_def_size.cpu},
    "memory": ${local.ecs.task_def_size.memory},
    "networkMode": "awsvpc",
    "interactive": true,
    "pseudoTerminal": true,
    "mountPoints": [],
    "logConfiguration": {
      "logDriver": "awslogs",
      "secretOptions": null,
      "options": {
        "awslogs-group": "${local.cloudwatch_log_group_name}",
        "awslogs-region": "${var.region}",
        "awslogs-stream-prefix": "vote"
      }
    },
    "portMappings": [{
      "containerPort": 5000,
      "hostPort": 5000
    }],
    "secrets": [
      {
        name = "REDIS_HOST"
        valueFrom = "${aws_ssm_parameter.ecs_task_vote_redis_host.arn}
      }
    ]
  }
]
EOF
}

data "template_file" "task_def_result_template" {
  template = <<EOF
[
  {
    "name": "result_app",
    "image": "${aws_ecr_repository.ecr_repo.repository_url}:result",
    "cpu" : ${local.ecs.task_def_size.cpu},
    "memory": ${local.ecs.task_def_size.memory},
    "networkMode": "awsvpc",
    "interactive": true,
    "pseudoTerminal": true,
    "mountPoints": [],
    "logConfiguration": {
      "logDriver": "awslogs",
      "secretOptions": null,
      "options": {
        "awslogs-group": "${local.cloudwatch_log_group_name}",
        "awslogs-region": "${var.region}",
        "awslogs-stream-prefix": "result"
      }
    },
    "portMappings": [{
      "containerPort": 5001,
      "hostPort": 5001
    }],
    "secrets": [
      {
        name = "DB_CONN_STRING"
        valueFrom = "${aws_ssm_parameter.ecs_task_result_db_string.arn}
      },
      {
        name = "VOTING_OPTION_A"
        value = "Cats"
      },
      {
        name = "VOTING_OPTION_B"
        value = "Dogs"
      },
      {
        name = "PUBLISH_INTERVAL_MS"
        value = "5000"
      }
    ]
  }
]
EOF
}

data "template_file" "task_def_worker_template" {
  template = <<EOF
[
  {
    "name": "worker_app",
    "image": "${aws_ecr_repository.ecr_repo.repository_url}:worker",
    "cpu" : ${local.ecs.task_def_size.cpu},
    "memory": ${local.ecs.task_def_size.memory},
    "networkMode": "awsvpc",
    "interactive": true,
    "pseudoTerminal": true,
    "mountPoints": [],
    "logConfiguration": {
      "logDriver": "awslogs",
      "secretOptions": null,
      "options": {
        "awslogs-group": "${local.cloudwatch_log_group_name}",
        "awslogs-region": "${var.region}",
        "awslogs-stream-prefix": "worker"
      }
    }
  }
]
EOF
}

