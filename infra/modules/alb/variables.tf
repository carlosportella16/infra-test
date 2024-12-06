variable "name_prefix" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "health_check_path" {
  type    = string
  default = "/"
}

variable "target_port" {
  type = number
}

variable "security_groups" {
  type    = list(string)
  default = []
}
