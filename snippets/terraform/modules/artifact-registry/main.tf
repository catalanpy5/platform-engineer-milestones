resource "google_artifact_registry_repository" "this" {
  project       = var.project_id
  location      = var.location
  repository_id = var.repository_id
  description   = var.description
  format        = "DOCKER"

  dynamic "cleanup_policies" {
    for_each = var.keep_recent_versions > 0 ? [1] : []
    content {
      id     = "keep-recent"
      action = "KEEP"
      most_recent_versions {
        keep_count = var.keep_recent_versions
      }
    }
  }
}
