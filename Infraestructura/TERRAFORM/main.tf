module "network" {
  source         = "./modules/network"
  enable_network = var.enable_network
  vpc_cidr       = var.vpc_cidr
  project_name   = var.project_name
  subnets_config = var.subnets_config
}

module "keypair" {
  source           = "./modules/keypair"
  key_name         = var.key_name
  private_key_path = abspath("${path.root}/${var.pem_private_key_path}")
}

module "security" {
  source       = "./modules/security"
  project_name = var.project_name
  vpc_id       = module.network.vpc_id
}

module "ami" {
  source     = "./modules/ami"
  ami_config = var.ami_config
}

module "alb" {
  source             = "./modules/alb"
  project_name       = var.project_name
  vpc_id             = module.network.vpc_id
  subnet_ids         = values(module.network.public_subnet_ids)
  security_group_ids = [module.security.alb_sg_id]
  alb_config         = var.alb_config
}

module "autoscaling" {
  source              = "./modules/autoscaling"
  enable_autoscaling  = var.enable_autoscaling
  project_name        = var.project_name
  ami_id              = module.ami.ami_id
  key_name            = module.keypair.key_name
  instance_type       = var.autoscaling_config.instance_type
  vpc_zone_identifier = values(module.network.public_subnet_ids)
  security_group_ids  = [module.security.ec2_sg_id]
  target_group_arns   = [module.alb.target_group_arn]
  autoscaling_config  = var.autoscaling_config
}

module "compute" {
  source                 = "./modules/compute"
  enable_compute         = var.enable_compute
  project_name           = var.project_name
  vpc_id                 = module.network.vpc_id
  subnet_map_ids         = module.network.subnet_ids
  instances_config       = var.instances_config
  vpc_security_group_ids = [module.security.ec2_sg_id]
  key_name               = module.keypair.key_name
  ami_id                 = module.ami.ami_id
}

module "database" {
  source            = "./modules/database"
  create_db         = var.create_db
  project_name      = var.project_name
  db_config         = var.db_config
  subnet_ids        = values(module.network.private_subnet_ids)
  security_group_id = module.security.db_sg_id
}