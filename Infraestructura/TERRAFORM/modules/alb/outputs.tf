output "alb_dns_name" {
  value = try(aws_lb.app[0].dns_name, "")
}

output "target_group_arn" {
  value = try(aws_lb_target_group.app[0].arn, "")
}
