output "vpc_id" {
  value = aws_vpc.my_vpc.id
}

output "subnet_ids" {
  value = aws_subnet.my_subnets[*].id
}

output "security_group_id" {
  value = aws_security_group.my_sg.id
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.my_cluster.name
}

output "ecr_repository_url" {
  value = aws_ecr_repository.my_api.repository_url
}

output "alb_dns_name" {
  value = aws_lb.ecs_alb.dns_name
}
