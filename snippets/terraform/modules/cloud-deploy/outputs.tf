output "pipeline_id" {
  value = google_clouddeploy_delivery_pipeline.this.id
}

output "target_ids" {
  value = { for k, t in google_clouddeploy_target.this : k => t.target_id }
}
