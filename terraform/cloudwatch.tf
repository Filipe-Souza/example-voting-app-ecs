resource "aws_cloudwatch_log_group" "log_group" {
  name = local.cloudwatch_log_group_name
  tags = local.default_tags
}
