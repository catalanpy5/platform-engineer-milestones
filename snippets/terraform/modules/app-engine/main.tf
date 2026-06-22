# App Engine application bootstrap (one per project). The react frontend
# versions themselves are deployed by CI/CD (gcloud app deploy), not Terraform.

resource "google_app_engine_application" "this" {
  project       = var.project_id
  location_id   = var.location_id
  database_type = var.database_type
}
