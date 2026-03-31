resource "google_compute_network" "new-vpc" {
  name                    = "${var.prefix}-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "primary" {
  name          = "${var.prefix}-vpc-subnet-0"
  ip_cidr_range = "10.10.0.0/24"
  region        = var.gcp_region
  network       = google_compute_network.new-vpc.id

  secondary_ip_range {
    range_name    = "${var.prefix}-subnet-0-pods"
    ip_cidr_range = "10.20.0.0/16"
  }

  secondary_ip_range {
    range_name    = "${var.prefix}-subnet-0-services"
    ip_cidr_range = "10.30.0.0/20"
  }
}
