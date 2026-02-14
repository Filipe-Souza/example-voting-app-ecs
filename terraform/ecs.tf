resource "aws_ecs_cluster" "voting_app_cluster" {
  name = local.ecs.cluster_name
  tags = local.default_tags
}

resource "aws_ecs_cluster_capacity_providers" "cluster_capacity_proviers" {
  cluster_name = aws_ecs_cluster.voting_app_cluster.name

  capacity_providers = ["FARGATE_SPOT", "FARGATE"]

  default_capacity_provider_strategy {
    base              = 0
    weight            = 1
    capacity_provider = "FARGATE_SPOT"
  }

  default_capacity_provider_strategy {
    base              = 3
    weight            = 3
    capacity_provider = "FARGATE"
  }
}
