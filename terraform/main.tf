############CREATING AN ECS CLUSTER#############

resource "aws_ecs_cluster" "apples-prod" {
  name = "${var.app_name}-${var.app_environment}-cluster"
  tags = {
    Name        = "${var.app_name}-ecs"
    Environment = var.app_environment
  }
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}



resource "aws_cloudwatch_log_group" "log-group" {
  name = "${var.app_name}-${var.app_environment}-logs"

  tags = {
    Application = var.app_name
    Environment = var.app_environment
  }
}

resource "aws_ecs_task_definition" "little-apples-task" {
  family                   = "app-service"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 1024
  memory                   = 4096
  execution_role_arn = aws_iam_role.ecsTaskExecutionRole.arn
  container_definitions    = jsonencode([
    {
      name      = "flask_web_server",
      image     = "docker.io/bensocho1312/bens-repo:python-app-${var.git_commit_sha}",
      cpu       = 512,
      memory    = 2048,
      essential = true,
      network_configuration = {
        security_groups = [aws_security_group.flask_sg.id],
        networks        = ["little_apples_network"]
      },
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-group = "${aws_cloudwatch_log_group.log-group.id}",
          awslogs-region = "${var.aws_region}",
          awslogs-stream-prefix = "${var.app_name}-${var.app_environment}"
        }
      },
      environment = [
        {
          name  = "MONGO_URI",
          value = "mongodb://admin:password@localhost:27017/my_flask_db"
        }
      ],
      portMappings = [
        {
          containerPort = 5000,
          hostPort      = 5000,
          protocol = "tcp",
          appProtocol = "http"
        }
      ],
      dependencies = [
        {
          containerName = "mongodb",
          condition     = "START"
        }
      ],
    },
    {
      name      = "mongodb",
      image     = "docker.io/bensocho1312/bens-repo:mongodb-${var.git_commit_sha}",
      cpu       = 512,
      memory    = 2048,
      essential = true,
      network_configuration = {
        security_groups = [aws_security_group.mongo_sg.id],
        networks        = ["little_apples_network"]
      },
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-group = "${aws_cloudwatch_log_group.log-group.id}",
          awslogs-region = "${var.aws_region}",
          awslogs-stream-prefix = "${var.app_name}-${var.app_environment}"
        }
      },
      portMappings = [
        {
          containerPort = 27017,
          hostPort      = 27017
        }
      ]
    }
  ])
 
}

resource "aws_ecs_service" "service" {
  name             = "service"
  cluster          = aws_ecs_cluster.apples-prod.id
  task_definition  = aws_ecs_task_definition.little-apples-task.id
  desired_count    = 3
  launch_type      = "FARGATE"
  platform_version = "LATEST"
  network_configuration {
        subnets = aws_subnet.private.*.id
        security_groups = [aws_security_group.apples_task_sg.id]
  }
  lifecycle {
    ignore_changes = [task_definition]
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.target_group.arn
    container_name   = "flask_web_server"
    container_port   = 5000
  }

  depends_on = [aws_lb_listener.listener]

}

