variable "project_id" {
  type = string
}

variable "name" {
  type = string
}

variable "location" {
  type        = string
  description = "Region (regional cluster) or zone (zonal cluster)."
}

variable "network" {
  type = string
}

variable "subnetwork" {
  type = string
}

variable "pods_range_name" {
  type = string
}

variable "services_range_name" {
  type = string
}

variable "release_channel" {
  type    = string
  default = "REGULAR"
}

variable "master_ipv4_cidr_block" {
  type    = string
  default = "172.16.0.0/28"
}

variable "master_authorized_networks" {
  type = list(object({
    cidr_block   = string
    display_name = string
  }))
  default = []
}

variable "node_service_account" {
  type        = string
  description = "Email of the service account used by node pools / NAP nodes."
}

variable "deletion_protection" {
  type    = bool
  default = true
}

# --- Node Auto-Provisioning (NAP) ---
variable "enable_node_auto_provisioning" {
  type    = bool
  default = false
}

variable "nap_min_cpu" {
  type    = number
  default = 4
}

variable "nap_max_cpu" {
  type    = number
  default = 200
}

variable "nap_min_memory_gb" {
  type    = number
  default = 16
}

variable "nap_max_memory_gb" {
  type    = number
  default = 800
}

# --- Node pools ---
variable "node_pools" {
  description = "Map of node pools keyed by pool name."
  type = map(object({
    machine_type = string
    min_count    = number
    max_count    = number
    disk_size_gb = optional(number, 100)
    spot         = optional(bool, false)
    labels       = optional(map(string), {})
    taints = optional(list(object({
      key    = string
      value  = string
      effect = string
    })), [])
  }))
}
