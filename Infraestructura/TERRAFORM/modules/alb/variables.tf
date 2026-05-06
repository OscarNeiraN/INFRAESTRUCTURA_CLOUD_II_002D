variable "project_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "security_group_ids" {
  type = list(string)
}

variable "enable_alb" {
  type    = bool
  default = true
}

variable "alb_config" {
  type = object({
    name           = string
    internal       = bool
    listener_port  = number
    target_port    = number
    protocol       = string
    target_protocol = string
  })
}
