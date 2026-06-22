variable "enable_istio" {
  type    = bool
  default = false
}

variable "enable_keda" {
  type    = bool
  default = false
}

variable "enable_kuberay" {
  type    = bool
  default = false
}

variable "istio_version" {
  type    = string
  default = "1.23.0"
}

variable "keda_version" {
  type    = string
  default = "2.15.1"
}

variable "kuberay_version" {
  type    = string
  default = "1.2.2"
}
