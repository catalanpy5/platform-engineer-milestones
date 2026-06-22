# #05 — GKE + KubeRay + KEDA (event-driven, cost-optimized).
# See architecture/gke-kuberay-keda-1.drawio. Data layer is intentionally
# omitted to match the diagram.

module "project_services" {
  source     = "../../modules/project-services"
  project_id = var.project_id
  services = [
    "compute.googleapis.com",
    "container.googleapis.com",
    "artifactregistry.googleapis.com",
    "run.googleapis.com",
    "pubsub.googleapis.com",
    "secretmanager.googleapis.com",
    "appengine.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "iam.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
  ]
}

module "network" {
  source     = "../../modules/network"
  project_id = var.project_id
  name       = "${var.name_prefix}-vpc"
  region     = var.region

  depends_on = [module.project_services]
}

# Least-privilege service account for node pools / NAP nodes.
resource "google_service_account" "nodes" {
  project      = var.project_id
  account_id   = "${var.name_prefix}-gke-nodes"
  display_name = "GKE node SA (${var.name_prefix})"
}

resource "google_project_iam_member" "nodes" {
  for_each = toset([
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter",
    "roles/monitoring.viewer",
    "roles/stackdriver.resourceMetadata.writer",
    "roles/artifactregistry.reader",
  ])
  project = var.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.nodes.email}"
}

module "gke" {
  source     = "../../modules/gke"
  project_id = var.project_id
  name       = "${var.name_prefix}-gke"
  location   = var.region

  network             = module.network.network_self_link
  subnetwork          = module.network.subnet_id
  pods_range_name     = module.network.pods_range_name
  services_range_name = module.network.services_range_name

  node_service_account       = google_service_account.nodes.email
  deletion_protection        = var.deletion_protection
  master_authorized_networks = var.master_authorized_networks

  # Bursty batch workloads: let NAP add capacity on demand.
  enable_node_auto_provisioning = true

  # Tenant isolation (#05): the heavy 45k-80k dim compute (OOM risk) runs in the
  # KubeRay *Ray worker pods*, so the per-tenant anti-affinity belongs on the Ray
  # worker pods (KubeRay workerGroupSpec) scheduled onto the tainted "ray" pool
  # with topologyKey kubernetes.io/hostname — different tenants never share a
  # node. The KEDA batch-worker only submits jobs to the Ray head and is
  # lightweight, so it does not need node isolation.
  node_pools = {
    system = {
      machine_type = "e2-standard-4"
      min_count    = 1
      max_count    = 3
      labels       = { role = "system" }
    }
    batch = {
      machine_type = "e2-standard-8"
      min_count    = 0
      max_count    = 30
      spot         = true
      labels       = { role = "batch-worker" }
      taints       = [{ key = "dedicated", value = "batch", effect = "NO_SCHEDULE" }]
    }
    ray = {
      machine_type = "e2-highmem-8"
      min_count    = 0
      max_count    = 20
      labels       = { role = "ray" }
      taints       = [{ key = "dedicated", value = "ray", effect = "NO_SCHEDULE" }]
    }
  }

  depends_on = [module.project_services]
}

module "artifact_registry" {
  source        = "../../modules/artifact-registry"
  project_id    = var.project_id
  location      = var.region
  repository_id = "${var.name_prefix}-images"

  depends_on = [module.project_services]
}

module "pubsub" {
  source            = "../../modules/pubsub"
  project_id        = var.project_id
  topic_name        = "jobs"
  subscription_name = "jobs-sub"

  depends_on = [module.project_services]
}

module "cloud_run_backend" {
  source     = "../../modules/cloud-run"
  project_id = var.project_id
  name       = "${var.name_prefix}-backend"
  region     = var.region
  image      = "us-docker.pkg.dev/cloudrun/container/hello" # bootstrap; CI rolls the real image

  min_instances = 0 # scale-to-zero
  max_instances = 20
  env = {
    PUBSUB_TOPIC = module.pubsub.topic_name
  }

  depends_on = [module.project_services]
}

module "app_engine" {
  source      = "../../modules/app-engine"
  project_id  = var.project_id
  location_id = var.app_engine_location

  depends_on = [module.project_services]
}

module "secret_manager" {
  source     = "../../modules/secret-manager"
  project_id = var.project_id
  secrets = {
    "app-runtime-config" = { labels = { app = "backend" } }
  }

  depends_on = [module.project_services]
}

module "addons" {
  source         = "../../modules/k8s-addons"
  enable_keda    = true
  enable_kuberay = true

  depends_on = [module.gke]
}
