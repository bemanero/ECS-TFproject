#----------------------------------------------------------------------------------------------------------
# Security Groups
locals {
  inbound_port  = [80, 22, 443]
  outbound_port = [0, 0, 0]
}

resource "aws_security_group" "sg-ecs" {
  vpc_id      = aws_vpc.vpc.id
  name        = "Ecs"
  description = "Security Group for Ecs-functions"

  dynamic "ingress" {
    for_each = local.inbound_port

    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = [var.vpc_cidr]
    }
  }

  dynamic "egress" {
    for_each = local.outbound_port

    content {
      from_port   = egress.value
      to_port     = egress.value
      protocol    = "-1"
      cidr_blocks = [var.public_access]
    }
  }
}

locals {
  inbound_ports  = [3306, 80, 22]
  outbound_ports = [0, 0, 0]
}
resource "aws_security_group" "sg-db" {
  vpc_id      = aws_vpc.vpc.id
  name        = "db"
  description = "Security Group for db"

  dynamic "ingress" {
    for_each = local.inbound_ports

    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = var.ingress-protocol
      cidr_blocks = [var.public_access]
    }
  }

  dynamic "egress" {
    for_each = local.outbound_ports

    content {
      from_port   = egress.value
      to_port     = egress.value
      protocol    = var.egress-protocol
      cidr_blocks = [var.vpc_cidr]
    }
  }
}

resource "aws_ecr_repository" "web-repo" {
  name = var.ECR-rep-name
  tags = {
    name = "${var.ECR-rep-name}"
  }
  force_delete = true
}
 #docker image
resource "docker_registry_image" "image-registry" {
  name = docker_image.image.name
  depends_on = [ docker_image.image ]
}
resource "docker_image" "image" {
  
  name = aws_ecr_repository.web-repo.repository_url
  build {
    context    = "./web-elearning-1"
    dockerfile = "Dockerfile"
  }
}
  
# }
#ECS
module "ECS" {

  source                    = "./modules/ECS"
  ECR-rep-name              = var.ECR-rep-name
  web_port                  = var.web_port
  host_port                 = var.host_port
  web_protocol              = var.web_protocol
  vpc_id                    = aws_vpc.vpc.id
  subnet_id                 = [aws_subnet.subnet[0].id, aws_subnet.subnet[1].id]
  ecs_sg_tags               = var.ecs_sg_tags
  fargate_cpu               = var.fargate_cpu
  fargate_memory            = var.fargate_memory
  container_cpu             = var.container_cpu
  container_memory          = var.container_memory 
  container_name            = var.container_name
  image_tag                 = var.image_tag
  cloudwatch_log_group_name = var.cloudwatch_log_group_name
  region                    = var.region
  ecs_cluster_name          = var.ecs_cluster_name
  service-name              = var.service-name
  desired_count             = var.desired_count
  sg_id                     = aws_security_group.sg-ecs.id
  image_name                = docker_image.image.name


}

#RDS--------------------------------------------------------------------
# resource "aws_db_subnet_group" "db_subnet_group" {
#   name       = "db_subnet_group"
#   subnet_ids = [aws_subnet.subnet[0].id, aws_subnet.subnet[1].id, aws_subnet.subnet[2].id, aws_subnet.subnet[3].id]

#   tags = {
#     Name = "DB subnet group"
#   }
# }
# module "rds" {
#   source               = "./modules/db"
#   db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name
#   vpc_cidr_block       = var.vpc_cidr
#   db_sg                = aws_security_group.sg-db.id
# }
# ENDPOINT------------------------------------------------------------------




