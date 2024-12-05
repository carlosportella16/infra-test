resource "aws_cloudwatch_log_group" "ecs_logs" {
  name              = "/ecs/my-container-logs"
  retention_in_days = 7
}
