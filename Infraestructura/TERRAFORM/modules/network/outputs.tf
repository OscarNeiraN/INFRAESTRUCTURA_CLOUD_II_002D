output "vpc_id" {
  value = one(aws_vpc.main[*].id)
}

output "subnet_ids" {
  value = { for k, v in aws_subnet.public : k => v.id }
  }