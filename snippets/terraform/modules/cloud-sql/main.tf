# MySQL backend DB (#02), private IP via Private Service Access.
# The instance depends on the PSA peering connection being ready.

resource "google_sql_database_instance" "this" {
  name             = var.name
  project          = var.project_id
  region           = var.region
  database_version = var.database_version

  deletion_protection = var.deletion_protection

  depends_on = [var.private_service_access_connection]

  settings {
    tier              = var.tier
    availability_type = var.availability_type
    disk_autoresize   = true

    ip_configuration {
      ipv4_enabled    = false
      private_network = var.network
    }

    backup_configuration {
      enabled            = true
      binary_log_enabled = true
      start_time         = "03:00"
    }

    maintenance_window {
      day  = 7
      hour = 4
    }
  }
}

resource "google_sql_database" "this" {
  name     = var.db_name
  project  = var.project_id
  instance = google_sql_database_instance.this.name
}

resource "random_password" "app" {
  length  = 24
  special = false
}

resource "google_sql_user" "app" {
  name     = var.db_user
  project  = var.project_id
  instance = google_sql_database_instance.this.name
  password = random_password.app.result
}
