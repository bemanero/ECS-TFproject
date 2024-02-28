variable "ECR-rep-name" {
  type        = string
  description = "(optional) describe your variable"
}
variable "vpc_id" {
  type        = string
  description = "vpc id"
}

variable "web_port" {
  type = string

}

variable "host_port" {
  type = string
}
variable "web_protocol" {
  type = string

}

variable "ecs_sg_tags" {
  type = string

}

variable "fargate_cpu" {
  type = number

}

variable "fargate_memory" {
  type = number

}

variable "container_cpu" {
  type = number
}

variable "container_memory" {
  type = number
}

variable "container_name" {
  type = string

}

variable "image_tag" {
  type = string

}

variable "cloudwatch_log_group_name" {
  type = string

}

variable "region" {
  type = string

}

variable "ecs_cluster_name" {
  type = string

}


variable "service-name" {
  type = string

}

variable "desired_count" {
  type        = string
  description = "desired amount of container to spawn"
}
variable "sg_id" {
  type        = string
  description = "security group id"
}

variable "subnet_id" {
  type        = list(string)
  description = "subnets ids"
}

variable "image_name" {
  type        = string
  description = "image name"
}