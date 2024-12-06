resource "aws_cloudwatch_log_group" "this" {
  name              = "/ecs/${var.log_prefix}"
  retention_in_days = var.retention

  tags = {
    Name = "/ecs/${var.log_prefix}"
  }
}
