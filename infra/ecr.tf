resource "aws_ecr_repository" "my_api" {
  name = "my-api-repository"

  image_scanning_configuration {
    scan_on_push = true
  }
}
