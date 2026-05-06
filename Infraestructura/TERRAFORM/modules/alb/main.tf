resource "aws_lb" "app" {
  count               = var.enable_alb ? 1 : 0
  name                = var.alb_config.name
  load_balancer_type  = "application"
  internal            = var.alb_config.internal
  security_groups     = var.security_group_ids
  subnets             = var.subnet_ids
  enable_deletion_protection = false
}

resource "aws_lb_target_group" "app" {
  count    = var.enable_alb ? 1 : 0
  name     = "${var.project_name}-tg"
  port     = var.alb_config.target_port
  protocol = var.alb_config.target_protocol
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    protocol            = var.alb_config.target_protocol
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "http" {
  count = var.enable_alb ? 1 : 0
  load_balancer_arn = aws_lb.app[0].arn
  port              = var.alb_config.listener_port
  protocol          = var.alb_config.protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app[0].arn
  }
}
