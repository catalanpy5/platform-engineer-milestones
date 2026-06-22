variable "project_id" {
  type = string
}

variable "region" {
  type    = string
  default = "asia-northeast3"
}

variable "app_engine_location" {
  type    = string
  default = "asia-northeast3"
}

variable "name_prefix" {
  type    = string
  default = "kr"
}

variable "master_authorized_networks" {
  type = list(object({
    cidr_block   = string
    display_name = string
  }))
  default = []
}

variable "deletion_protection" {
  type    = bool
  default = true
}
