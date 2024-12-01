resource "aws_ecr_repository" "my_api" {
  name = "my-api-repository"

  image_scanning_configuration {
    scan_on_push = true
  }

  lifecycle {
    ignore_changes = [name] # Evita conflitos ao recriar o repositório com o mesmo nome
  }

  tags = {
    recreate_trigger = timestamp() # Força recriação com base no timestamp
  }
}
