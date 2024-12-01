resource "aws_ecr_repository" "my_api" {
  name = "my-api-repository"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_lifecycle_policy" "my_api_policy" {
  repository = aws_ecr_repository.my_api.name

  policy = <<EOF
  {
    "rules": [
      {
        "rulePriority": 1,
        "description": "Expire untagged images",
        "selection": {
          "tagStatus": "untagged",
          "countType": "imageCountMoreThan",
          "countNumber": 10
        },
        "action": {
          "type": "expire"
        }
      }
    ]
  }
EOF
}
