# Progressive (canary) delivery pipeline targeting the GKE cluster (#02).
# Helm/Kustomize render + rollout is defined in the skaffold config; here we
# only model the pipeline and its GKE targets.

resource "google_clouddeploy_target" "this" {
  for_each = var.targets

  name     = each.key
  project  = var.project_id
  location = var.location

  gke {
    cluster = each.value.cluster
  }

  require_approval = each.value.require_approval
}

resource "google_clouddeploy_delivery_pipeline" "this" {
  name     = var.pipeline_name
  project  = var.project_id
  location = var.location

  serial_pipeline {
    dynamic "stages" {
      for_each = var.stage_order
      content {
        target_id = google_clouddeploy_target.this[stages.value].target_id
      }
    }
  }
}
