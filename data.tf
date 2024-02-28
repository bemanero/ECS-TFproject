data "aws_availability_zones" "avz" {
  exclude_names = [var.exclude_names]
}

data "aws_route53_zone" "project" {
  name = "projects4life.click"
}

data "aws_ecr_authorization_token" "token" {
}

