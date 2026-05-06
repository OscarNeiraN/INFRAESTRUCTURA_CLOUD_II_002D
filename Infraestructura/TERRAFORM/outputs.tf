output "vpc_id" { value = module.network.vpc_id }
#output "ec2_public_ips" { value = module.compute.instance_ips }
output "rds_endpoint" { value = module.database.db_endpoint }

output "servidores_info" {
  value       = module.compute.instance_public_ips
  description = "Lista de servidores desplegados y sus IPs"
}
output "id_grupo_seguridad" {
  value = module.security.security_group_id
}