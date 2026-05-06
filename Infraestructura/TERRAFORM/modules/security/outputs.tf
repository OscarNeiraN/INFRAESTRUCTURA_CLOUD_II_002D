output "security_group_id" {
  value = one(aws_security_group.main[*].id)
}