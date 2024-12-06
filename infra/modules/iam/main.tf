resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]
  thumbprint_list = ["9e99a48a9960b14926bb7f3da0e346e3b165b2aa"]
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:${var.github_org}/${var.github_repo}:ref:refs/heads/main"]
    }
  }
}

data "aws_iam_policy_document" "terraform_access" {
  statement {
    actions = [
      "ec2:*",
      "ecs:*",
      "ecr:*",
      "iam:*",
      "logs:*",
      "elasticloadbalancing:*",
      "cloudwatch:*",
      "autoscaling:*",
      "sts:*"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role" "github_actions_role" {
  name               = "${var.github_org}-${var.github_repo}-terraform-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_policy" "terraform_policy" {
  name        = "${var.github_org}-${var.github_repo}-terraform-policy"
  description = "Policy with permissions for Terraform to manage infrastructure"
  policy      = data.aws_iam_policy_document.terraform_access.json
}

resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.github_actions_role.name
  policy_arn = aws_iam_policy.terraform_policy.arn
}
