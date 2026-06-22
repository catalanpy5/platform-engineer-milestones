variable "project_id" {
  type = string
}

variable "name" {
  type = string
}

variable "region" {
  type = string
}

variable "database_version" {
  type    = string
  default = "MYSQL_8_0"
}

variable "tier" {
  type    = string
  default = "db-custom-2-7680"
}

variable "availability_type" {
  type    = string
  default = "REGIONAL"
}

variable "network" {
  type        = string
  description = "VPC self_link/id for the private IP connection."
}

variable "private_service_access_connection" {
  type        = any
  default     = null
  description = "PSA connection output from the network module (dependency)."
}

variable "db_name" {
  type    = string
  default = "app"
}

variable "db_user" {
  type    = string
  default = "app"
}

variable "deletion_protection" {
  type    = bool
  default = true
}
