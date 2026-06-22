variable "project_id" {
  type = string
}

variable "name" {
  type = string
}

variable "zone" {
  type        = string
  description = "Filestore location (zone, e.g. asia-northeast3-a)."
}

variable "tier" {
  type    = string
  default = "BASIC_HDD"
}

variable "share_name" {
  type    = string
  default = "share1"
}

variable "capacity_gb" {
  type    = number
  default = 1024
}

variable "network" {
  type        = string
  description = "VPC network name to attach the instance to."
}
