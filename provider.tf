terraform {
  # backend "s3" {
  #   bucket         = "backend-tf001"
  #   key            = "global/TFstate_files/terraform.tfstate"
  #   dynamodb_table = "state_lock"
  #   region         = "eu-west-2"
  #   encrypt        = true
  # }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

provider "aws" {
  region = var.region
}

provider "docker" {
  registry_auth {
    address  = aws_ecr_repository.web-repo.repository_url
    username = data.aws_ecr_authorization_token.token.user_name
    password = data.aws_ecr_authorization_token.token.password

  }

}