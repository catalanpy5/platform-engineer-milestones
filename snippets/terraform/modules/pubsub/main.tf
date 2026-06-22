# Jobs queue for the event-driven (#05) pipeline. KEDA scales the
# batch-worker Deployment from the subscription backlog (SubscriptionSize).

resource "google_pubsub_topic" "this" {
  name    = var.topic_name
  project = var.project_id
}

# Optional dead-letter topic for messages that exceed max delivery attempts.
resource "google_pubsub_topic" "dead_letter" {
  count = var.enable_dead_letter ? 1 : 0

  name    = "${var.topic_name}-dlq"
  project = var.project_id
}

resource "google_pubsub_subscription" "this" {
  name    = var.subscription_name
  project = var.project_id
  topic   = google_pubsub_topic.this.id

  ack_deadline_seconds = var.ack_deadline_seconds

  # Long-running batch jobs: never expire the subscription on inactivity.
  expiration_policy {
    ttl = ""
  }

  retry_policy {
    minimum_backoff = "10s"
    maximum_backoff = "600s"
  }

  dynamic "dead_letter_policy" {
    for_each = var.enable_dead_letter ? [1] : []
    content {
      dead_letter_topic     = google_pubsub_topic.dead_letter[0].id
      max_delivery_attempts = var.max_delivery_attempts
    }
  }
}
