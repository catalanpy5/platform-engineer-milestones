output "topic_id" {
  value = google_pubsub_topic.this.id
}

output "topic_name" {
  value = google_pubsub_topic.this.name
}

output "subscription_id" {
  value = google_pubsub_subscription.this.id
}

output "subscription_name" {
  value = google_pubsub_subscription.this.name
}
