module "network" {
  source         = "./modules/network"
  enable_network = var.enable_network   
  vpc_cidr       = var.vpc_cidr
  project_name   = var.project_name
  subnets_config = var.subnets_config
}

module "security" {
  source          = "./modules/security"
  project_name    = var.project_name
  vpc_id          = module.network.vpc_id
  enable_security = var.enable_network
  
  ingress_rules = [
    { port = 22, cidr = ["0.0.0.0/0"] },
    { port = 80, cidr = ["0.0.0.0/0"] }  
  ]
}

data "aws_ami" "selected_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

module "compute" {
  source           = "./modules/compute"
  enable_compute   = var.enable_compute
  project_name     = var.project_name
  vpc_id           = module.network.vpc_id
  subnet_map_ids   = module.network.subnet_ids
  instances_config = var.instances_config
  vpc_security_group_ids = [module.security.security_group_id]
  ami_id           = data.aws_ami.selected_ami.id
}

module "database" {
  source            = "./modules/database"
  create_db         = var.create_db     
  project_name      = var.project_name  
  db_config         = var.db_config
  subnet_ids        = values(module.network.subnet_ids)
  security_group_id = module.security.security_group_id
}