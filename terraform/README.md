<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 6.32.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.32.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.8.1 |
| <a name="provider_template"></a> [template](#provider\_template) | 2.2.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_alb.elb_result](https://registry.terraform.io/providers/hashicorp/aws/6.32.0/docs/resources/alb) | resource |
| [aws_alb.elb_vote](https://registry.terraform.io/providers/hashicorp/aws/6.32.0/docs/resources/alb) | resource |
| [aws_alb_listener.elb_result_listener](https://registry.terraform.io/providers/hashicorp/aws/6.32.0/docs/resources/alb_listener) | resource |
| [aws_alb_listener.elb_vote_listener](https://registry.terraform.io/providers/hashicorp/aws/6.32.0/docs/resources/alb_listener) | resource |
| [aws_alb_target_group.elb_result_tg](https://registry.terraform.io/providers/hashicorp/aws/6.32.0/docs/resources/alb_target_group) | resource |
| [aws_alb_target_group.elb_vote_tg](https://registry.terraform.io/providers/hashicorp/aws/6.32.0/docs/resources/alb_target_group) | resource |
| [aws_cloudwatch_log_group.log_group](https://registry.terraform.io/providers/hashicorp/aws/6.32.0/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_metric_alarm.alb_healthy_hosts_low](https://registry.terraform.io/providers/hashicorp/aws/6.32.0/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.alb_p95_latency_high](https://registry.terraform.io/providers/hashicorp/aws/6.32.0/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.alb_request_count_low](https://registry.terraform.io/providers/hashicorp/aws/6.32.0/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.alb_target_5xx](https://registry.terraform.io/providers/hashicorp/aws/6.32.0/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_db_instance.persistant_database](https://registry.terraform.io/providers/hashicorp/aws/6.32.0/docs/resources/db_instance) | resource |
| [aws_ecr_repository.ecr_repo](https://registry.terraform.io/providers/hashicorp/aws/6.32.0/docs/resources/ecr_repository) | resource |
| [aws_ecs_cluster.voting_app_cluster](https://registry.terraform.io/providers/hashicorp/aws/6.32.0/docs/resources/ecs_cluster) | resource |
| [aws_ecs_cluster_capacity_providers.cluster_capacity_providers](https://registry.terraform.io/providers/hashicorp/aws/6.32.0/docs/resources/ecs_cluster_capacity_providers) | resource |
| [aws_ecs_service.ecs_service_result](https://registry.terraform.io/providers/hashicorp/aws/6.32.0/docs/resources/ecs_service) | resource |
| [aws_ecs_service.ecs_service_vote](https://registry.terraform.io/providers/hashicorp/aws/6.32.0/docs/resources/ecs_service) | resource |
| [aws_ecs_service.ecs_service_worker](https://registry.terraform.io/providers/hashicorp/aws/6.32.0/docs/resources/ecs_service) | resource |
| [aws_ecs_task_definition.task_def_result](https://registry.terraform.io/providers/hashicorp/aws/6.32.0/docs/resources/ecs_task_definition) | resource |
| [aws_ecs_task_definition.task_def_vote](https://registry.terraform.io/providers/hashicorp/aws/6.32.0/docs/resources/ecs_task_definition) | resource |
| [aws_ecs_task_definition.task_def_worker](https://registry.terraform.io/providers/hashicorp/aws/6.32.0/docs/resources/ecs_task_definition) | resource |
| [aws_elasticache_cluster.aws_redis](https://registry.terraform.io/providers/hashicorp/aws/6.32.0/docs/resources/elasticache_cluster) | resource |
| [aws_elasticache_parameter_group.default](https://registry.terraform.io/providers/hashicorp/aws/6.32.0/docs/resources/elasticache_parameter_group) | resource |
| [aws_elasticache_subnet_group.cache_subnet_group](https://registry.terraform.io/providers/hashicorp/aws/6.32.0/docs/resources/elasticache_subnet_group) | resource |
| [aws_iam_role.ecs_task_def_execution_role](https://registry.terraform.io/providers/hashicorp/aws/6.32.0/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.ecs_task_def_execution_role_policy](https://registry.terraform.io/providers/hashicorp/aws/6.32.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_security_group.databases_sg](https://registry.terraform.io/providers/hashicorp/aws/6.32.0/docs/resources/security_group) | resource |
| [aws_security_group.main_sg](https://registry.terraform.io/providers/hashicorp/aws/6.32.0/docs/resources/security_group) | resource |
| [aws_ssm_parameter.ecs_task_exec_iam_role](https://registry.terraform.io/providers/hashicorp/aws/6.32.0/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.ecs_task_result_db_string](https://registry.terraform.io/providers/hashicorp/aws/6.32.0/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.rds_db_password](https://registry.terraform.io/providers/hashicorp/aws/6.32.0/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.rds_db_username](https://registry.terraform.io/providers/hashicorp/aws/6.32.0/docs/resources/ssm_parameter) | resource |
| [random_password.rds_db_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [aws_iam_policy_document.ecs_task_def_assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/6.32.0/docs/data-sources/iam_policy_document) | data source |
| [aws_subnets.default_subnets](https://registry.terraform.io/providers/hashicorp/aws/6.32.0/docs/data-sources/subnets) | data source |
| [aws_vpc.default_vpc](https://registry.terraform.io/providers/hashicorp/aws/6.32.0/docs/data-sources/vpc) | data source |
| [template_file.task_def_result_template](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.task_def_vote_template](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.task_def_worker_template](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alarm_actions"></a> [alarm\_actions](#input\_alarm\_actions) | Supply the list of AWS SNS topics ARNs here for the cloudwatch metrics for the ALARM conditions | `list(string)` | `[]` | no |
| <a name="input_database_username"></a> [database\_username](#input\_database\_username) | Username for the PostgreSQL database | `string` | `"postgres"` | no |
| <a name="input_db_security_group_description"></a> [db\_security\_group\_description](#input\_db\_security\_group\_description) | Allows all traffic from the apps SG to the resouces. | `string` | `"Allows traffic from the application security group"` | no |
| <a name="input_healthy_hosts_min"></a> [healthy\_hosts\_min](#input\_healthy\_hosts\_min) | The minimum number of instances in the TG to consider it low. | `number` | `1` | no |
| <a name="input_ok_actions"></a> [ok\_actions](#input\_ok\_actions) | Supply the list of AWS SNS topics ARNs here for the cloudwatch metrics for the OK conditions | `list(string)` | `[]` | no |
| <a name="input_p95_latency_seconds_threshold"></a> [p95\_latency\_seconds\_threshold](#input\_p95\_latency\_seconds\_threshold) | Numer of seconds to evaluate the 95% of the requests response times. | `number` | `1.5` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | The global project name to identify resources. Try using no special characters and short names | `string` | `"votingapp"` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region for building resources | `string` | `"us-east-1"` | no |
| <a name="input_request_count_min"></a> [request\_count\_min](#input\_request\_count\_min) | The minimum number of requests in 5 minutes to consider the application has no traffic. | `number` | `1` | no |
| <a name="input_security_group_description"></a> [security\_group\_description](#input\_security\_group\_description) | Allows all traffic from the internet to the resources | `string` | `"Allows traffic from internet"` | no |
| <a name="input_target_5xx_threshold"></a> [target\_5xx\_threshold](#input\_target\_5xx\_threshold) | The number of 5xx errors in 5 minutes to consider the application is unhealth. | `number` | `5` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ecs_cluster_name"></a> [ecs\_cluster\_name](#output\_ecs\_cluster\_name) | The ECS cluster name |
| <a name="output_ecs_services_names"></a> [ecs\_services\_names](#output\_ecs\_services\_names) | The names of the services created |
| <a name="output_ecs_tasks_family"></a> [ecs\_tasks\_family](#output\_ecs\_tasks\_family) | The names of the ECS family task names created. |
| <a name="output_url_ecr_repo"></a> [url\_ecr\_repo](#output\_url\_ecr\_repo) | The project ECR address |
| <a name="output_url_postgres"></a> [url\_postgres](#output\_url\_postgres) | The PostgreSQL database host address |
| <a name="output_url_redis"></a> [url\_redis](#output\_url\_redis) | The Redis cluster host address |
| <a name="output_url_result_app"></a> [url\_result\_app](#output\_url\_result\_app) | The ELB address of the Results app |
| <a name="output_url_vote_app"></a> [url\_vote\_app](#output\_url\_vote\_app) | The ELB address of the Vote app |
<!-- END_TF_DOCS -->