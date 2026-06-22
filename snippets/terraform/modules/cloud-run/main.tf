# Serverless backend service. min_instance_count = 0 gives scale-to-zero (#05);
# set > 0 to keep warm instances for latency-sensitive paths.

resource "google_cloud_run_v2_service" "this" {
  name     = var.name
  project  = var.project_id
  location = var.region
  ingress  = var.ingress

  template {
    service_account = var.service_account_email

    scaling {
      min_instance_count = var.min_instances
      max_instance_count = var.max_instances
    }

    containers {
      image = var.image

      resources {
        limits = {
          cpu    = var.cpu
          memory = var.memory
        }
      }

      dynamic "env" {
        for_each = var.env
        content {
          name  = env.key
          value = env.value
        }
      }
    }

    dynamic "vpc_access" {
      for_each = var.vpc_connector == null ? [] : [1]
      content {
        connector = var.vpc_connector
        egress    = "PRIVATE_RANGES_ONLY"
      }
    }
  }

  lifecycle {
    # Image tag is rolled by CI/CD, not Terraform.
    ignore_changes = [template[0].containers[0].image]
  }
}
