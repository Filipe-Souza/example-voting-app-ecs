locals {
  project_name              = "${var.project_name}-${terraform.workspace}"
  cloudwatch_log_group_name = "/ecs/${local.project_name}"
  default_tags = {
    ResourceOwner = "filipe@lullabies.com.br",
    Project       = local.project_name
  }
  ecs = {
    cluster_name                = local.project_name
    task_def_exec_iam_role_name = local.project_name
    task_def_size = {
      cpu    = 256
      memory = 512
    }
    services_names = {
      vote   = "${local.project_name}-vote"
      result = "${local.project_name}-result"
      worker = "${local.project_name}-worker"
    }
  }
  elb = {
    // Watch out for the 32 characters limit of ELB and TG resources from AWS.
    names = {
      vote   = "${local.project_name}-vote"
      result = "${local.project_name}-result"
      worker = "${local.project_name}-worker"
    }
  }
  rds_database_identifier = local.project_name
  ecr_repo_name           = local.project_name
}
