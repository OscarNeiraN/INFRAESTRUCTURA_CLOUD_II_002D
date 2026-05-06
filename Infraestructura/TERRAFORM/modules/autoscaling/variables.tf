variable "project_name" {
  type = string
}

variable "enable_autoscaling" {
  type    = bool
  default = true
}

variable "ami_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "security_group_ids" {
  type = list(string)
}

variable "vpc_zone_identifier" {
  type = list(string)
}

variable "key_name" {
  type = string
}

variable "target_group_arns" {
  type = list(string)
}

variable "autoscaling_config" {
  type = object({
    min_size                 = number
    max_size                 = number
    desired_capacity         = number
    health_check_type        = string
    health_check_grace_period = number
  })
}
