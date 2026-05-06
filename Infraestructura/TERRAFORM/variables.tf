variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "enable_network" { type = bool }
variable "enable_compute" { type = bool }
variable "create_db" { type = bool }

variable "project_name" { type = string }
variable "vpc_cidr" { type = string }

variable "key_name" {
  type = string
}

variable "pem_private_key_path" {
  type = string
}

variable "enable_alb" {
  type    = bool
  default = false
}

variable "enable_autoscaling" {
  type    = bool
  default = false
}

variable "ami_config" {
  type = object({
    most_recent = bool
    owners      = list(string)
    filters = list(object({
      name   = string
      values = list(string)
    }))
  })
}

variable "alb_config" {
  type = object({
    name            = string
    internal        = bool
    listener_port   = number
    target_port     = number
    protocol        = string
    target_protocol = string
  })
}

variable "autoscaling_config" {
  type = object({
    min_size                  = number
    max_size                  = number
    desired_capacity          = number
    instance_type             = string
    health_check_type         = string
    health_check_grace_period = number
  })
}

variable "subnets_config" {
  type = map(object({
    az      = string
    net_num = number
    public  = bool
  }))
}

variable "instances_config" {
  type = map(object({
    subnet_key = string
    #ami        = string
    type = string
  }))
}

variable "db_config" {
  type = object({
    engine         = string
    engine_version = string
    instance_class = string
    username       = string
    password       = string
    storage        = number
  })
  sensitive = true
}