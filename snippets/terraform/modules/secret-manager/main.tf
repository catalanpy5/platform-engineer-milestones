# Creates secret *containers* (DB/ES creds, etc.). Values are injected out of
# band (CI/CD or manual) to avoid persisting secrets in Terraform state.
# Pass a non-null `initial_value` only for bootstrap/non-sensitive cases.

resource "google_secret_manager_secret" "this" {
  for_each = var.secrets

  project   = var.project_id
  secret_id = each.key

  labels = each.value.labels

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "this" {
  for_each = { for k, v in var.secrets : k => v if v.initial_value != null }

  secret      = google_secret_manager_secret.this[each.key].id
  secret_data = each.value.initial_value
}
