# Cluster add-ons installed via Helm. Toggle per architecture:
#   #02 -> enable_istio
#   #05 -> enable_keda + enable_kuberay
# Requires kubernetes/helm providers configured against the target cluster
# (see the stack's providers.tf).

# --- Istio service mesh (#02) ---
resource "helm_release" "istio_base" {
  count = var.enable_istio ? 1 : 0

  name             = "istio-base"
  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "base"
  version          = var.istio_version
  namespace        = "istio-system"
  create_namespace = true
}

resource "helm_release" "istiod" {
  count = var.enable_istio ? 1 : 0

  name       = "istiod"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "istiod"
  version    = var.istio_version
  namespace  = "istio-system"

  depends_on = [helm_release.istio_base]
}

resource "helm_release" "istio_ingress" {
  count = var.enable_istio ? 1 : 0

  name             = "istio-ingressgateway"
  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "gateway"
  version          = var.istio_version
  namespace        = "istio-ingress"
  create_namespace = true

  depends_on = [helm_release.istiod]
}

# --- KEDA (#05) ---
resource "helm_release" "keda" {
  count = var.enable_keda ? 1 : 0

  name             = "keda"
  repository       = "https://kedacore.github.io/charts"
  chart            = "keda"
  version          = var.keda_version
  namespace        = "keda"
  create_namespace = true
}

# --- KubeRay operator (#05) ---
resource "helm_release" "kuberay_operator" {
  count = var.enable_kuberay ? 1 : 0

  name             = "kuberay-operator"
  repository       = "https://ray-project.github.io/kuberay-helm/"
  chart            = "kuberay-operator"
  version          = var.kuberay_version
  namespace        = "ray-system"
  create_namespace = true
}
