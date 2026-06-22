output "name" {
  value = google_filestore_instance.this.name
}

output "ip_address" {
  value = google_filestore_instance.this.networks[0].ip_addresses[0]
}
