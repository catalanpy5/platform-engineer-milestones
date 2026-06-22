# Shared filesystem mounted into pods via the Filestore CSI driver (#02 —
# realtime-svc writes analysis results).

resource "google_filestore_instance" "this" {
  name     = var.name
  project  = var.project_id
  location = var.zone
  tier     = var.tier

  file_shares {
    name        = var.share_name
    capacity_gb = var.capacity_gb
  }

  networks {
    network = var.network
    modes   = ["MODE_IPV4"]
  }
}
