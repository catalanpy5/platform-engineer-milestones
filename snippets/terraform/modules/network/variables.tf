variable "project_id" {
  type = string
}

variable "name" {
  type        = string
  description = "Base name for the VPC and derived resources."
}

variable "region" {
  type = string
}

variable "subnet_cidr" {
  type    = string
  default = "10.10.0.0/20"
}

variable "pods_range_name" {
  type    = string
  default = "pods"
}

variable "pods_cidr" {
  type    = string
  default = "10.20.0.0/14"
}

variable "services_range_name" {
  type    = string
  default = "services"
}

variable "services_cidr" {
  type    = string
  default = "10.24.0.0/20"
}

variable "enable_private_service_access" {
  type        = bool
  default     = false
  description = "Reserve a PSA range and peer it (required for Cloud SQL private IP)."
}
