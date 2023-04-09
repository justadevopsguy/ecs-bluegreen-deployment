resource "aws_ecs_cluster" "ecs_ecs_cluster" {
  name = "${local.app_name}-${local.environment}-cluster"
  tags = merge(local.default_tags, {
    Name = "${local.app_name}-ecs"
  })

}

resource "aws_ecs_task_definition" "ecs_task" {
  family = "${local.app_name}-task"

  container_definitions = jsonencode([{
    name      = "${local.app_name}-${local.environment}-container"
    image     = "${aws_ecr_repository.ecs_ecr.repository_url}:latest"
    essential = true
    secrets = [{
      name      = "MONGO_HOST"
      valueFrom = "arn:aws:ssm:ap-southeast-1:182155805005:parameter/production/mongodb/host"
    }]
    portMappings = [{
      containerPort = 8080
      hostPort      = 8080
    }]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = aws_cloudwatch_log_group.log_group.id
        awslogs-region        = "ap-southeast-1"
        awslogs-stream-prefix = "ecs"
      }
    }
  }])

  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory                   = "512"
  cpu                      = "256"
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn
  task_role_arn            = aws_iam_role.ecsTaskExecutionRole.arn

  tags = merge(local.default_tags, {
    Name = "${local.app_name}-ecs-td"
  })
}

resource "aws_ecs_service" "ecs_ecs_service" {
  name                 = "${local.app_name}-${local.environment}-ecs-service"
  cluster              = aws_ecs_cluster.ecs_ecs_cluster.id
  task_definition      = aws_ecs_task_definition.ecs_task.arn
  launch_type          = "FARGATE"
  scheduling_strategy  = "REPLICA"
  desired_count        = 1
  force_new_deployment = true

  network_configuration {
    subnets          = data.terraform_remote_state.vpc_database.outputs.private_subnet_id
    assign_public_ip = false
    security_groups = [
      aws_security_group.service_security_group.id,
      aws_security_group.load_balancer_security_group.id
    ]

  }

  load_balancer {
    target_group_arn = aws_lb_target_group.target_group.arn
    container_name   = "${local.app_name}-${local.environment}-container"
    container_port   = 8080
  }

  deployment_controller {
    type = "CODE_DEPLOY"
  }
  depends_on = [aws_lb_listener.listener]

  lifecycle {
    ignore_changes = [
      desired_count,   # Updated possibly by auto scaling
      task_definition, # Updated by deployments
      load_balancer, # Updated by deployment 
    ]
  }
}

resource "aws_cloudwatch_log_group" "log_group" {
  name = "${local.app_name}-${local.environment}-logs"

  tags = {
    Application = local.app_name
    Environment = local.environment
  }
}