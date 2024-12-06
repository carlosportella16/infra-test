variable "aws_region" {
  type        = string
  default     = "sa-east-1"
  description = "Região AWS"
}

variable "aws_profile" {
  type        = string
  default     = "default"
  description = "Perfil AWS"
}

variable "application_name" {
  type        = string
  default     = "java-spring-app"
  description = "Nome da aplicação"
}

variable "image_tag" {
  type        = string
  default     = "latest"
  description = "Tag da imagem no ECR"
}

variable "task_cpu" {
  type        = number
  default     = 256
  description = "CPU da task ECS"
}

variable "task_memory" {
  type        = number
  default     = 512
  description = "Memória da task ECS"
}

variable "desired_count" {
  type        = number
  default     = 2
  description = "Quantidade desejada de tarefas ECS"
}

variable "max_capacity" {
  type        = number
  default     = 4
  description = "Capacidade máxima para auto-scaling"
}

variable "min_capacity" {
  type        = number
  default     = 2
  description = "Capacidade mínima para auto-scaling"
}

variable "cpu_utilization_target" {
  type        = number
  default     = 50
  description = "Target de utilização de CPU para scaling"
}

variable "container_port" {
  type        = number
  default     = 8080
  description = "Porta do container"
}

variable "log_retention" {
  type        = number
  default     = 7
  description = "Retenção dos logs em dias"
}

variable "vpc_cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnets_cidrs" {
  type    = list(string)
  default = ["10.0.1.0/24","10.0.2.0/24"]
}

variable "private_subnets_cidrs" {
  type    = list(string)
  default = ["10.0.3.0/24","10.0.4.0/24"]
}
