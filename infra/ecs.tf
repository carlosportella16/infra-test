resource "aws_ecs_cluster" "my_cluster" {
  name = "my-ecs-cluster"
}

resource "aws_ecs_task_definition" "my_task" {
  family                   = "my-api-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name        = "my-api-container"
      image       = "${aws_ecr_repository.my_api.repository_url}:latest"
      essential   = true
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "my_service" {
  name            = "my-api-service"
  cluster         = aws_ecs_cluster.my_cluster.id
  task_definition = aws_ecs_task_definition.my_task.arn
  desired_count   = 1

  launch_type = "FARGATE"

  network_configuration {
    subnets         = aws_subnet.my_subnets[*].id
    security_groups = [aws_security_group.my_sg.id]
    assign_public_ip = true
  }
}

