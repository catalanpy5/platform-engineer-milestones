variable "project_id" {
  type = string
}

variable "name" {
  type = string
}

variable "region" {
  type = string
}

variable "image" {
  type        = string
  description = "Initial container image; subsequent rollouts are CI/CD-driven."
}

variable "service_account_email" {
  type    = string
  default = null
}

variable "ingress" {
  type    = string
  default = "INGRESS_TRAFFIC_ALL"
}

variable "min_instances" {
  type    = number
  default = 0
}

variable "max_instances" {
  type    = number
  default = 10
}

variable "cpu" {
  type    = string
  default = "1"
}

variable "memory" {
  type    = string
  default = "512Mi"
}

variable "env" {
  type    = map(string)
  default = {}
}

variable "vpc_connector" {
  type    = string
  default = null
}
