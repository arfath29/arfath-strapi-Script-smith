resource "aws_cloudwatch_log_group" "strapi_logs" {
  name              = "/ecs/strapi"
  retention_in_days = 14
}
resource "aws_cloudwatch_dashboard" "strapi_dashboard" {
  dashboard_name = "StrapiDashboard"
  dashboard_body = jsonencode({
    widgets = [
      {
        type = "metric"
        x    = 0, y = 0, width = 6, height = 6,
        properties = {
          metrics = [
            ["AWS/ECS", "CPUUtilization", "ClusterName", aws_ecs_cluster.strapi_cluster.name],
            [".", "MemoryUtilization", ".", aws_ecs_cluster.strapi_cluster.name]
          ],
          period = 300,
          stat   = "Average",
          region = var.aws_region,
          title  = "Strapi ECS CPU & Memory"
        }
      }
    ]
  })
}
resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "StrapiHighCPU"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  dimensions = {
    ClusterName = aws_ecs_cluster.strapi_cluster.name
    ServiceName = aws_ecs_service.strapi_service.name
  }
}

