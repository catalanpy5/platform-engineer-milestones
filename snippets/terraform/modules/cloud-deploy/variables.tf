variable "project_id" {
  type = string
}

variable "location" {
  type = string
}

variable "pipeline_name" {
  type    = string
  default = "realtime-svc"
}

variable "targets" {
  description = "Map of target name => { cluster, require_approval }."
  type = map(object({
    cluster          = string
    require_approval = optional(bool, false)
  }))
}

variable "stage_order" {
  type        = list(string)
  description = "Ordered list of target names defining the pipeline stages."
}
