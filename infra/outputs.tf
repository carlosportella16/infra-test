output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}

output "service_sg_id" {
  value = aws_security_group.ecs_service_sg.id
}
