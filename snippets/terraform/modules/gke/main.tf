# VPC-native, private GKE cluster with Workload Identity and (optional)
# Node Auto-Provisioning. Node pools are driven by a map so callers can
# express tenant-isolated pools (labels/taints) — see #05.

resource "google_container_cluster" "this" {
  provider = google-beta

  name     = var.name
  location = var.location
  project  = var.project_id

  network    = var.network
  subnetwork = var.subnetwork

  # Manage node pools as separate resources.
  remove_default_node_pool = true
  initial_node_count       = 1
  deletion_protection      = var.deletion_protection

  release_channel {
    channel = var.release_channel
  }

  networking_mode = "VPC_NATIVE"
  ip_allocation_policy {
    cluster_secondary_range_name  = var.pods_range_name
    services_secondary_range_name = var.services_range_name
  }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = var.master_ipv4_cidr_block
  }

  dynamic "master_authorized_networks_config" {
    for_each = length(var.master_authorized_networks) > 0 ? [1] : []
    content {
      dynamic "cidr_blocks" {
        for_each = var.master_authorized_networks
        content {
          cidr_block   = cidr_blocks.value.cidr_block
          display_name = cidr_blocks.value.display_name
        }
      }
    }
  }

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  addons_config {
    horizontal_pod_autoscaling {
      disabled = false # HPA — used by both #02 and #05
    }
    http_load_balancing {
      disabled = false
    }
  }

  # NAP / cluster autoscaler — lets the cluster grow node pools on demand
  # (bursty KubeRay/KEDA workloads in #05).
  dynamic "cluster_autoscaling" {
    for_each = var.enable_node_auto_provisioning ? [1] : []
    content {
      enabled = true
      resource_limits {
        resource_type = "cpu"
        minimum       = var.nap_min_cpu
        maximum       = var.nap_max_cpu
      }
      resource_limits {
        resource_type = "memory"
        minimum       = var.nap_min_memory_gb
        maximum       = var.nap_max_memory_gb
      }
      auto_provisioning_defaults {
        service_account = var.node_service_account
        oauth_scopes    = ["https://www.googleapis.com/auth/cloud-platform"]
      }
    }
  }

  lifecycle {
    ignore_changes = [initial_node_count]
  }
}

resource "google_container_node_pool" "pools" {
  for_each = var.node_pools

  name     = each.key
  project  = var.project_id
  location = var.location
  cluster  = google_container_cluster.this.name

  autoscaling {
    min_node_count = each.value.min_count
    max_node_count = each.value.max_count
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  node_config {
    machine_type    = each.value.machine_type
    disk_size_gb    = each.value.disk_size_gb
    disk_type       = "pd-balanced"
    spot            = each.value.spot
    service_account = var.node_service_account
    oauth_scopes    = ["https://www.googleapis.com/auth/cloud-platform"]
    labels          = each.value.labels

    # Per-tenant taints enable strict node isolation (#05): batch-worker pods
    # tolerate their tenant taint, so the scheduler keeps tenants apart.
    dynamic "taint" {
      for_each = each.value.taints
      content {
        key    = taint.value.key
        value  = taint.value.value
        effect = taint.value.effect
      }
    }

    workload_metadata_config {
      mode = "GKE_METADATA"
    }
  }
}
