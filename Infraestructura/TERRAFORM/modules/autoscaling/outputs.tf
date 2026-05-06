output "autoscaling_group_id" {
  value = try(aws_autoscaling_group.app[0].id, "")
}

output "launch_template_id" {
  value = try(aws_launch_template.app[0].id, "")
}
