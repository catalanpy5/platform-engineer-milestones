output "network_id" {
  value = google_compute_network.this.id
}

output "network_name" {
  value = google_compute_network.this.name
}

output "network_self_link" {
  value = google_compute_network.this.self_link
}

output "subnet_id" {
  value = google_compute_subnetwork.this.id
}

output "subnet_name" {
  value = google_compute_subnetwork.this.name
}

output "pods_range_name" {
  value = var.pods_range_name
}

output "services_range_name" {
  value = var.services_range_name
}

output "private_service_access_connection" {
  value       = var.enable_private_service_access ? google_service_networking_connection.psa[0].id : null
  description = "Use as an explicit dependency for Cloud SQL private-IP instances."
}
