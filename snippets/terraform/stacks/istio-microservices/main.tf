# #02 — GKE microservices + Istio canary delivery.
# See architecture/gke-istio-4.drawio.

module "project_services" {
  source     = "../../modules/project-services"
  project_id = var.project_id
  services = [
    "compute.googleapis.com",
    "container.googleapis.com",
    "artifactregistry.googleapis.com",
    "run.googleapis.com",
    "sqladmin.googleapis.com",
    "file.googleapis.com",
    "clouddeploy.googleapis.com",
    "secretmanager.googleapis.com",
    "servicenetworking.googleapis.com",
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

  # Required for Cloud SQL private IP.
  enable_private_service_access = true

  depends_on = [module.project_services]
}

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

  # HPA + cluster autoscaling carry the canary/stable workloads.
  enable_node_auto_provisioning = true

  node_pools = {
    system = {
      machine_type = "e2-standard-4"
      min_count    = 1
      max_count    = 3
      labels       = { role = "system" }
    }
    app = {
      machine_type = "e2-standard-4"
      min_count    = 2
      max_count    = 10
      labels       = { role = "app" }
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

module "cloud_sql" {
  source     = "../../modules/cloud-sql"
  project_id = var.project_id
  name       = "${var.name_prefix}-mysql"
  region     = var.region

  network                           = module.network.network_self_link
  private_service_access_connection = module.network.private_service_access_connection
  deletion_protection               = var.deletion_protection

  depends_on = [module.project_services]
}

module "filestore" {
  source     = "../../modules/filestore"
  project_id = var.project_id
  name       = "${var.name_prefix}-fs"
  zone       = var.zone
  network    = module.network.network_name

  depends_on = [module.project_services]
}

module "secret_manager" {
  source     = "../../modules/secret-manager"
  project_id = var.project_id
  secrets = {
    "db-creds" = { labels = { app = "realtime-svc" } }
    "es-creds" = { labels = { app = "realtime-svc" } }
  }

  depends_on = [module.project_services]
}

module "cloud_run_backend" {
  source     = "../../modules/cloud-run"
  project_id = var.project_id
  name       = "${var.name_prefix}-backend"
  region     = var.region
  image      = "us-docker.pkg.dev/cloudrun/container/hello" # bootstrap; CI rolls the real image

  depends_on = [module.project_services]
}

module "app_engine" {
  source      = "../../modules/app-engine"
  project_id  = var.project_id
  location_id = var.app_engine_location

  depends_on = [module.project_services]
}

module "cloud_deploy" {
  source        = "../../modules/cloud-deploy"
  project_id    = var.project_id
  location      = var.region
  pipeline_name = "realtime-svc"

  targets = {
    prod = {
      cluster = "projects/${var.project_id}/locations/${var.region}/clusters/${module.gke.name}"
    }
  }
  stage_order = ["prod"]

  depends_on = [module.project_services]
}

module "addons" {
  source       = "../../modules/k8s-addons"
  enable_istio = true

  depends_on = [module.gke]
}
