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

resource "google_compute_firewall" "egress_allow_all" {
  name      = "${var.prefix}-egress-allow-all"
  network   = google_compute_network.new-vpc.name
  direction = "EGRESS"
  priority  = 1000

  destination_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "all"
  }
}

resource "google_compute_firewall" "ingress_http_https_nodeports" {
  name    = "${var.prefix}-ingress-lb-http-https-nodeports"
  network = google_compute_network.new-vpc.name

  direction     = "INGRESS"
  priority      = 900
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "tcp"
    ports    = ["80", "443", "30000-32767"]
  }
}

resource "google_compute_router" "new-router" {
  name    = "${var.prefix}-router"
  region  = var.gcp_region
  network = google_compute_network.new-vpc.id
}

resource "google_compute_router_nat" "new-nat" {
  name   = "${var.prefix}-nat"
  router = google_compute_router.new-router.name
  region = google_compute_router.new-router.region

  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

data "google_compute_zones" "get-all-zones" {
  region = var.gcp_region
}


