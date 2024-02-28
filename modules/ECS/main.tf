
#ECS
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs-execution-role"

  assume_role_policy = jsonencode({
    "Version" : "2008-10-17",
    "Statement" : [
      {
        "Sid" : "",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "ecs-tasks.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}
resource "aws_iam_policy" "ecs_task_execution_policy" {
  name = "ecs-execution-policy"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource" : "*"
      }
    ]
  })
}
# Attach execution policy to execution role
resource "aws_iam_role_policy_attachment" "ecs_role_attach" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.ecs_task_execution_policy.arn
}


#TASK DEFINITION
resource "aws_cloudwatch_log_group" "yada" {
  name = var.cloudwatch_log_group_name

}
resource "aws_ecs_task_definition" "task" {
  family                   = "web"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "${var.fargate_cpu}"
  memory                   = var.fargate_memory
  task_role_arn            = aws_iam_role.ecs_task_execution_role.arn
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  
  container_definitions = jsonencode([
    {
      name      = var.container_name
      essential = true
      image     = var.image_name
      cpu       = var.container_cpu
      memory    = var.container_memory

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = var.cloudwatch_log_group_name
          awslogs-region        = var.region
          awslogs-stream-prefix = "ecs"
        }
      }
      portMappings = [
        {
          hostPort      = "${tonumber(var.host_port)}"
          containerPort = "${tonumber(var.web_port)}"
          protocol      = "tcp"
          
        }
      ]
    }
  ])
runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  tags = {
    name = var.container_name
  }
}

# Load balancer
resource "aws_lb" "ecs_alb" {
  name               = "ecs-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.sg_id]
  subnets            = var.subnet_id

  tags = {
    Name = "ecs-alb"
  }
}

resource "aws_lb_listener" "ecs_alb_listener" {
  load_balancer_arn = aws_lb.ecs_alb.arn
  port              = var.web_port
  protocol          = var.web_protocol
  

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_tg.arn
  }
}

resource "aws_lb_target_group" "ecs_tg" {
  name        = "ecs-target-group"
  port        = var.web_port
  protocol    = var.web_protocol
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path = "/"
  }
}
#ECS CLUSTER
resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.ecs_cluster_name
  tags = {
    name = "${var.ecs_cluster_name}"
  }
}

#ECS SERVICE
resource "aws_ecs_service" "default" {
  name            = var.service-name
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.task.arn
  desired_count   = var.desired_count
  
  launch_type     = "FARGATE"



  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_tg.arn
    container_name   = var.container_name
    container_port   = var.web_port
  }
  network_configuration {
    security_groups  = [var.sg_id]
    subnets          = var.subnet_id
    assign_public_ip = true
  }

  tags = {
    name = "${var.service-name}"
  }

}

