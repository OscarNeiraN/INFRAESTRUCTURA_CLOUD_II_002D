resource "aws_launch_template" "app" {
  count = var.enable_autoscaling ? 1 : 0

  name_prefix   = "${var.project_name}-lt-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  vpc_security_group_ids = var.security_group_ids

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "app" {
  count = var.enable_autoscaling ? 1 : 0

  name                = "${var.project_name}-asg"
  max_size            = var.autoscaling_config.max_size
  min_size            = var.autoscaling_config.min_size
  desired_capacity    = var.autoscaling_config.desired_capacity
  vpc_zone_identifier = var.vpc_zone_identifier

  launch_template {
    id      = aws_launch_template.app[0].id
    version = "$Latest"
  }

  target_group_arns = var.target_group_arns

  health_check_type         = var.autoscaling_config.health_check_type
  health_check_grace_period = var.autoscaling_config.health_check_grace_period

  tag {
    key                 = "Name"
    value               = lower("${var.project_name}-asg")
    propagate_at_launch = true
  }
}
