variable "project_id" {
  type        = string
  description = "Target GCP project ID."
}

variable "services" {
  type        = list(string)
  description = "List of API service names to enable (e.g. container.googleapis.com)."
}
