variable "region" {
  description = " provider region"
  type        = string
  default     = "eu-west-2"
}
variable "project_name" {
  type        = string
  description = "project name"
  default     = "E-portal"
}
variable "vpc_cidr" {
  description = "Value of cidr block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "tenancy" {
  description = "instance tenancy for the VPC"
  type        = string
  default     = "default"
}
variable "exclude_names" {
  description = "names to me excluded"
  type        = string
  default     = "eu-west-2c"
}
variable "subnet_names" {
  description = "subnets names for the VPC"
  type        = list(string)
  default     = ["web-public-1", "web-public-2", "app-private-1", "app-private-2"]
}

variable "subnet_cidr_block" {
  description = "Value of cidr block for the subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24", "10.0.4.0/24"]
}


variable "public_access" {
  description = "public access cidr block"
  type        = string
  default     = "0.0.0.0/0"
}
variable "local_access" {
  description = "local access"
  type        = string
  default     = "local"
}



#db_security group-----------------------------------------------------------------------------
variable "ingress-protocol" {
  description = "network ingress protocol"
  type        = string
  default     = "tcp"
}
variable "egress-protocol" {
  description = "network egress protocol"
  type        = string
  default     = "-1"
}

#ECS VARIABLES ---------------------------------------------------------------------------------

variable "ecs_sg_tags" {
  type        = string
  description = "ecs cluster tag"
  default     = "ecs security group"
}

variable "ecs_cluster_name" {
  type        = string
  description = "Cluster name"
  default     = "App-cluster"
}

variable "ECR-rep-name" {
  type        = string
  description = "ECR repository name"
  default     = "elearning"
}

variable "web_port" {
  type        = number
  description = "web port to reach endpoint"
  default     = "80"
}
variable "host_port" {
  type = number
  description = "host port to allow communication with host server"
  default = "80"
}
variable "web_protocol" {
  type        = string
  description = "web port protocol"
  default     = "HTTP"
}
variable "fargate_cpu" {
  type        = number
  description = "fargate central processing unit"
  default     = "1024"
}

variable "fargate_memory" {
  type        = number
  description = "fargate memory"
  default     = "2048"
}
variable "container_cpu" {
  type = number
  default = "512"
}
variable "container_memory" {
  type = number
  default = "1024"
}
variable "container_name" {
  type        = string
  description = "Name of container"
  default     = "web"
}

variable "image_tag" {
  type        = string
  description = "docker image tag identifier"
  default     = "web"
}

variable "cloudwatch_log_group_name" {
  type        = string
  description = "cloud watch group name"
  default     = "ecs_log"
}
variable "service-name" {
  type    = string
  default = "App-service"
}

variable "desired_count" {
  type        = number
  description = "Desired amount of task to deliver"
  default     = "2"
}

#---------------------------------------------------------------------------------

variable "aws_route53_record_type" {
  type    = string
  default = "A"
}