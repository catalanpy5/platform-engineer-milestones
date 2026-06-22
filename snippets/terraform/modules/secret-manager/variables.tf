variable "project_id" {
  type = string
}

variable "secrets" {
  description = "Map of secret_id => { labels, initial_value }."
  type = map(object({
    labels        = optional(map(string), {})
    initial_value = optional(string, null)
  }))
  default = {}
}
