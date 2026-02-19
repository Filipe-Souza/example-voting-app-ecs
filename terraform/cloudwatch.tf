resource "aws_cloudwatch_log_group" "log_group" {
  name = local.cloudwatch_log_group_name
  tags = local.default_tags
}

locals {
  result_alb = aws_alb.elb_result.arn_suffix
  vote_alb   = aws_alb.elb_vote.arn_suffix
  result_tg  = aws_alb_target_group.elb_result_tg.arn_suffix
  vote_tg    = aws_alb_target_group.elb_vote_tg.arn_suffix
}

resource "aws_cloudwatch_metric_alarm" "alb_p95_latency_high" {
  alarm_name          = "${var.project_name}-alb-p95-latency-high"
  alarm_description   = "ALB target response time p95 is high on at least one load balancer"
  comparison_operator = "GreaterThanThreshold"
  threshold           = var.p95_latency_seconds_threshold
  evaluation_periods  = 5
  datapoints_to_alarm = 3
  treat_missing_data  = "notBreaching"

  alarm_actions = var.alarm_actions
  ok_actions    = var.ok_actions

  metric_query {
    id          = "m1"
    return_data = false
    metric {
      namespace   = "AWS/ApplicationELB"
      metric_name = "TargetResponseTime"
      stat        = "p95"
      period      = 60
      dimensions = {
        LoadBalancer = local.result_alb
        TargetGroup  = local.result_tg
      }
    }
  }

  metric_query {
    id          = "m2"
    return_data = false
    metric {
      namespace   = "AWS/ApplicationELB"
      metric_name = "TargetResponseTime"
      stat        = "p95"
      period      = 60
      dimensions = {
        LoadBalancer = local.vote_alb
        TargetGroup  = local.vote_tg
      }
    }
  }
  metric_query {
    id          = "e1"
    expression  = "MAX([m1,m2])"
    label       = "Max p95 TargetResponseTime across both ALBs"
    return_data = true
  }
}

resource "aws_cloudwatch_metric_alarm" "alb_target_5xx" {
  alarm_name          = "${var.project_name}-alb-target-5xx"
  alarm_description   = "Target 5XX count is high across ALBs"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold           = var.target_5xx_threshold
  evaluation_periods  = 5
  datapoints_to_alarm = 2
  treat_missing_data  = "notBreaching"

  alarm_actions = var.alarm_actions
  ok_actions    = var.ok_actions

  metric_query {
    id          = "m1"
    return_data = false
    metric {
      namespace   = "AWS/ApplicationELB"
      metric_name = "HTTPCode_Target_5XX_Count"
      stat        = "Sum"
      period      = 60
      dimensions = {
        LoadBalancer = local.result_alb
        TargetGroup  = local.result_tg
      }
    }
  }

  metric_query {
    id          = "m2"
    return_data = false
    metric {
      namespace   = "AWS/ApplicationELB"
      metric_name = "HTTPCode_Target_5XX_Count"
      stat        = "Sum"
      period      = 60
      dimensions = {
        LoadBalancer = local.vote_alb
        TargetGroup  = local.vote_tg
      }
    }
  }

  metric_query {
    id          = "e1"
    expression  = "m1+m2"
    label       = "Total Target 5XX across both ALBs"
    return_data = true
  }
}

resource "aws_cloudwatch_metric_alarm" "alb_healthy_hosts_low" {
  alarm_name          = "${var.project_name}-alb-healthy-hosts-low"
  alarm_description   = "Healthy targets too low on at least one target group"
  comparison_operator = "LessThanThreshold"
  threshold           = var.healthy_hosts_min
  evaluation_periods  = 3
  datapoints_to_alarm = 2
  treat_missing_data  = "breaching"

  alarm_actions = var.alarm_actions
  ok_actions    = var.ok_actions

  metric_query {
    id          = "m1"
    return_data = false
    metric {
      namespace   = "AWS/ApplicationELB"
      metric_name = "HealthyHostCount"
      stat        = "Minimum"
      period      = 60
      dimensions = {
        LoadBalancer = local.result_alb
        TargetGroup  = local.result_tg
      }
    }
  }

  metric_query {
    id          = "m2"
    return_data = false
    metric {
      namespace   = "AWS/ApplicationELB"
      metric_name = "HealthyHostCount"
      stat        = "Minimum"
      period      = 60
      dimensions = {
        LoadBalancer = local.vote_alb
        TargetGroup  = local.vote_tg
      }
    }
  }

  # Alert if either TG is unhealthy (min of both)
  metric_query {
    id          = "e1"
    expression  = "MIN([m1,m2])"
    label       = "Min HealthyHostCount across both target groups"
    return_data = true
  }
}

resource "aws_cloudwatch_metric_alarm" "alb_request_count_low" {
  alarm_name          = "${var.project_name}-alb-requestcount-low"
  alarm_description   = "Total ALB RequestCount is low (possible outage/routing issue)"
  comparison_operator = "LessThanThreshold"
  threshold           = var.request_count_min
  evaluation_periods  = 2
  datapoints_to_alarm = 2
  treat_missing_data  = "breaching"

  alarm_actions = var.alarm_actions
  ok_actions    = var.ok_actions

  metric_query {
    id          = "m1"
    return_data = false
    metric {
      namespace   = "AWS/ApplicationELB"
      metric_name = "RequestCount"
      stat        = "Sum"
      period      = 300
      dimensions = {
        LoadBalancer = local.result_alb
      }
    }
  }

  metric_query {
    id          = "m2"
    return_data = false
    metric {
      namespace   = "AWS/ApplicationELB"
      metric_name = "RequestCount"
      stat        = "Sum"
      period      = 300
      dimensions = {
        LoadBalancer = local.vote_alb
      }
    }
  }

  metric_query {
    id          = "e1"
    expression  = "m1+m2"
    label       = "Total RequestCount across both ALBs"
    return_data = true
  }
}