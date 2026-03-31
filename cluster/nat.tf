resource "google_compute_router" "new-router" {
  name    = "${var.prefix}-router"
  network = google_compute_network.new-vpc.id
}

resource "google_compute_router_nat" "new-nat" {
  name   = "${var.prefix}-nat"
  router = google_compute_router.new-router.name

  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}
