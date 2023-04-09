resource "aws_alb" "application_load_balancer" {
  name               = "${local.app_name}-${local.environment}-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = data.terraform_remote_state.vpc_database.outputs.public_subnet_id
  security_groups    = [aws_security_group.load_balancer_security_group.id]

  tags = {
    Name        = "${local.app_name}-alb"
    Environment = local.environment
  }
}

resource "aws_lb_target_group" "target_group" {
  name        = "${local.app_name}-${local.environment}-blue"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = data.terraform_remote_state.vpc_database.outputs.vpc_id

  deregistration_delay = "10"
  health_check {
    healthy_threshold   = "3"
    interval            = "300"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = "/"
    unhealthy_threshold = "2"
  }

  tags = {
    Name        = "${local.app_name}-lb-tg"
    Environment = local.environment
  }
}

resource "aws_lb_target_group" "target_group_green" {
  name        = "${local.app_name}-${local.environment}-green"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = data.terraform_remote_state.vpc_database.outputs.vpc_id

  deregistration_delay = "10"
  health_check {
    healthy_threshold   = "3"
    interval            = "300"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = "/"
    unhealthy_threshold = "2"
  }

  tags = {
    Name        = "${local.app_name}-lb-tg-green"
    Environment = local.environment
  }
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_alb.application_load_balancer.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      host        = "#{host}"
      path        = "/#{path}"
      port        = "443"
      protocol    = "HTTPS"
      query       = "#{query}"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "listener_https" {
  load_balancer_arn = aws_alb.application_load_balancer.id
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = "arn:aws:acm:ap-southeast-1:182155805005:certificate/869d9869-ad5c-414a-810e-0048b3dafa9b"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.id
  }
}
