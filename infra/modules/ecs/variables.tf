variable "cluster_name" {
  type = string
}

variable "service_name" {
  type = string
}

variable "task_cpu" {
  type = number
}

variable "task_memory" {
  type = number
}

variable "desired_count" {
  type = number
}

variable "max_capacity" {
  type = number
}

variable "min_capacity" {
  type = number
}

variable "container_image" {
  type = string
}

variable "container_port" {
  type = number
}

variable "log_group_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "security_groups" {
  type = list(string)
}

variable "alb_target_group_arn" {
  type = string
}

variable "cpu_utilization_target" {
  type = number
}

variable "region" {
  type    = string
  default = "sa-east-1"
}
