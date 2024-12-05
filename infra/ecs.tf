resource "aws_ecs_cluster" "my_cluster" {
  name = "my-ecs-cluster"
}


# Definição de Tarefa ECS
resource "aws_ecs_task_definition" "my_task" {
  family                   = "my-task"
  container_definitions    = jsonencode([
    {
      name      = "my-container",
      image     = "${aws_ecr_repository.my_api.repository_url}:latest",
      memory    = 512,
      cpu       = 256,
      essential = true,
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
        }
      ]
    }
  ])
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory                   = "512"
  cpu                      = "256"
}

# Serviço ECS
resource "aws_ecs_service" "my_service" {
  name            = "my-ecs-service"
  cluster         = aws_ecs_cluster.my_cluster.id
  task_definition = aws_ecs_task_definition.my_task.arn
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = aws_subnet.my_subnets[*].id
    security_groups = [aws_security_group.my_sg.id]
    assign_public_ip = true
  }

  desired_count = 1
  depends_on = [
    aws_ecs_task_definition.my_task
  ]
}
