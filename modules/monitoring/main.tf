# Log group

resource "aws_cloudwatch_log_group" "cloudwatch_group" {
  name = "${var.project_name}-log-group-${var.env}"
  tags = var.tags
}

# Alarms

resource "aws_cloudwatch_metric_alarm" "cpu-alarm-high" {
  alarm_name          = "${var.project_name}-cpu-alarm-high-${var.env}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  threshold           = 10
  statistic           = "Average"
  actions_enabled     = true
  alarm_actions       = var.alarm_actions_high_cpu

  dimensions = {
    "AutoScalingGroupName" = var.autoscaling_group_name
  }
}

resource "aws_cloudwatch_metric_alarm" "cpu-alarm-low" {
  alarm_name          = "${var.project_name}-cpu-alarm-low-${var.env}"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  threshold           = 10
  statistic           = "Average"
  actions_enabled     = true
  alarm_actions       = var.alarm_actions_low_cpu

  dimensions = {
    "AutoScalingGroupName" = var.autoscaling_group_name
  }
}

resource "aws_cloudwatch_metric_alarm" "errors-5xx" {
  alarm_name                = "${var.project_name}-5xx-errors-high-${var.env}"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 2
  threshold                 = 0.1
  alarm_description         = "Request error rate has exceeded 10%"
  insufficient_data_actions = []
  alarm_actions             = var.alarm_actions_high_5xx_errors

  metric_query {
    id          = "e1"
    expression  = "m2/m1"
    label       = "Error Rate"
    return_data = "true"
  }

  metric_query {
    id = "m1"

    metric {
      metric_name = "RequestCount"
      namespace   = "AWS/ApplicationELB"
      period      = 60
      stat        = "Sum"
      unit        = "Count"

      dimensions = {
        LoadBalancer = var.alb_arn_suffix
      }
    }
  }

  metric_query {
    id = "m2"

    metric {
      metric_name = "HTTPCode_Target_5XX_Count"
      namespace   = "AWS/ApplicationELB"
      period      = 60
      stat        = "Sum"
      unit        = "Count"

      dimensions = {
        LoadBalancer = var.alb_arn_suffix
      }
    }
  }
}
