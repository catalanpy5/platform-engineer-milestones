output "installed" {
  description = "Which add-ons were enabled."
  value = {
    istio   = var.enable_istio
    keda    = var.enable_keda
    kuberay = var.enable_kuberay
  }
}
