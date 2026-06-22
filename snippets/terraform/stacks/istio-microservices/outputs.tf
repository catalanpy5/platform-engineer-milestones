output "gke_cluster" {
  value = module.gke.name
}

output "artifact_registry_url" {
  value = module.artifact_registry.repository_url
}

output "cloud_sql_connection_name" {
  value = module.cloud_sql.connection_name
}

output "filestore_ip" {
  value = module.filestore.ip_address
}

output "cloud_run_uri" {
  value = module.cloud_run_backend.uri
}

output "cloud_deploy_pipeline" {
  value = module.cloud_deploy.pipeline_id
}

output "addons" {
  value = module.addons.installed
}
