variable "project_id" {
  type = string
}

variable "location" {
  type = string
}

variable "repository_id" {
  type = string
}

variable "description" {
  type    = string
  default = "Container images (managed by Terraform)."
}

variable "keep_recent_versions" {
  type        = number
  default     = 10
  description = "Cleanup policy: keep N most recent versions (0 disables)."
}
