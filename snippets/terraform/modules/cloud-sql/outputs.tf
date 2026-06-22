output "instance_name" {
  value = google_sql_database_instance.this.name
}

output "connection_name" {
  value = google_sql_database_instance.this.connection_name
}

output "private_ip_address" {
  value = google_sql_database_instance.this.private_ip_address
}

output "generated_password" {
  description = "Store this in Secret Manager; not printed in plan output by default."
  value       = random_password.app.result
  sensitive   = true
}
