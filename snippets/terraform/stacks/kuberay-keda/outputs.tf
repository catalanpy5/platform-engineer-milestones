output "gke_cluster" {
  value = module.gke.name
}

output "artifact_registry_url" {
  value = module.artifact_registry.repository_url
}

output "pubsub_topic" {
  value = module.pubsub.topic_name
}

output "pubsub_subscription" {
  value = module.pubsub.subscription_name
}

output "cloud_run_uri" {
  value = module.cloud_run_backend.uri
}

output "addons" {
  value = module.addons.installed
}
