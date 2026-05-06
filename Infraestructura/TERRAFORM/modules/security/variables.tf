variable "project_name" { type = string }
variable "vpc_id"       { type = string }

variable "enable_security" {
  type    = bool
  default = true
}

variable "ingress_rules" {
  description = "Lista de reglas de entrada: puerto y CIDR"
  type = list(object({
    port = number
    cidr = list(string)
  }))
}