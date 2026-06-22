variable "project_id" {
  type = string
}

variable "topic_name" {
  type    = string
  default = "jobs"
}

variable "subscription_name" {
  type    = string
  default = "jobs-sub"
}

variable "ack_deadline_seconds" {
  type    = number
  default = 600
}

variable "enable_dead_letter" {
  type    = bool
  default = true
}

variable "max_delivery_attempts" {
  type    = number
  default = 5
}
