variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "enable_network" { type = bool }
variable "enable_compute" { type = bool }
variable "create_db"      { type = bool }

variable "project_name" { type = string }
variable "vpc_cidr"     { type = string }

variable "subnets_config" {
  type = map(object({
    az      = string
    net_num = number
  }))
}

variable "instances_config" {
  type = map(object({
    subnet_key = string
    #ami        = string
    type       = string
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