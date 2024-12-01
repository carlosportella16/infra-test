resource "aws_ecr_repository" "my_api" {
  name = "my-api-repository"

  image_scanning_configuration {
    scan_on_push = true
  }
}

lifecycle {
  create_before_destroy = true
  prevent_destroy       = false
}

tags = {
  recreate_trigger = timestamp() # Força recriação com base no timestamp
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
