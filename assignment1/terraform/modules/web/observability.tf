# ref: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm
# CPU still reports on an idle instance; request-count style metrics often stay empty.
resource "aws_cloudwatch_metric_alarm" "web_cpu" {
  alarm_name          = "${local.name}-web-cpu"
  alarm_description   = "Average CPUUtilization on the ${local.name} web instance"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = var.alarm_cpu_threshold
  treat_missing_data  = "notBreaching"

  dimensions = {
    InstanceId = aws_instance.web.id
  }

  tags = merge(local.common_tags, {
    Name = "${local.name}-web-cpu"
  })
}
