variable "project_id" {
  type = string
}

variable "location_id" {
  type        = string
  description = "App Engine location (e.g. asia-northeast3). Immutable once set."
}

variable "database_type" {
  type    = string
  default = "CLOUD_FIRESTORE"
}
