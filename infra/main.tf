terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "carlosportella16-sa-east-1-terraform-statefile"  # Substitua pelo seu bucket
    key            = "env:/prod/infra.tfstate"         # Caminho do arquivo de state no bucket
    region         = "sa-east-1"                   # Região do bucket S3
    dynamodb_table = "carlosportella16-sa-east-1-terraform-lock"          # Tabela DynamoDB para lock
    encrypt        = true
  }
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

# Cria VPC
module "vpc" {
  source                = "./modules/vpc"
  vpc_cidr_block        = var.vpc_cidr_block
  public_subnets_cidrs  = var.public_subnets_cidrs
  private_subnets_cidrs = var.private_subnets_cidrs
}

# Security Group do ALB
resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "SG do ALB"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "HTTP inbound"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security Group do ECS Service
resource "aws_security_group" "ecs_service_sg" {
  name        = "ecs-service-sg"
  description = "SG do ECS Service"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description     = "Inbound do ALB na porta 8080"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

module "cw_logs" {
  source      = "./modules/cloudwatch-logs"
  log_prefix  = var.application_name
  retention   = var.log_retention
}

module "alb" {
  source             = "./modules/alb"
  name_prefix        = var.application_name
  vpc_id             = module.vpc.vpc_id
  subnet_ids         = module.vpc.public_subnets
  health_check_path  = "/actuator/health"
  target_port        = var.container_port
  security_groups    = [aws_security_group.alb_sg.id]
}

module "ecr" {
  source            = "./modules/ecr"
  repository_name   = var.application_name
  image_tag_mutable = true
}

module "ecs" {
  source                  = "./modules/ecs"
  cluster_name            = "${var.application_name}-cluster"
  service_name            = "${var.application_name}-service"
  task_cpu                = var.task_cpu
  task_memory             = var.task_memory
  desired_count           = var.desired_count
  max_capacity            = var.max_capacity
  min_capacity            = var.min_capacity
  container_image         = "${module.ecr.repository_url}:${var.image_tag}"
  container_port          = var.container_port
  log_group_name          = module.cw_logs.log_group_name
  vpc_id                  = module.vpc.vpc_id
  subnet_ids              = module.vpc.private_subnets
  security_groups         = [aws_security_group.ecs_service_sg.id]
  alb_target_group_arn    = module.alb.target_group_arn
  cpu_utilization_target  = var.cpu_utilization_target
  region                  = var.aws_region
}
