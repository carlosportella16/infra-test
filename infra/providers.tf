terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.78.0"
    }
  }
}

provider "aws" {
  region  = "sa-east-1" # Região desejada
  profile = "carlosportella"   # Nome do perfil configurado
}
