output "name" {
  value = google_container_cluster.this.name
}

output "id" {
  value = google_container_cluster.this.id
}

output "location" {
  value = google_container_cluster.this.location
}

output "endpoint" {
  value     = google_container_cluster.this.endpoint
  sensitive = true
}

output "ca_certificate" {
  value     = google_container_cluster.this.master_auth[0].cluster_ca_certificate
  sensitive = true
}

output "node_pools" {
  value = keys(google_container_node_pool.pools)
}
