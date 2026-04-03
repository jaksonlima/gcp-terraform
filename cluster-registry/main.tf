module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 12.0"

  project_id   = var.gcp_project_id
  network_name = "${var.prefix}-vpc"

  subnets = [
    {
      subnet_name   = "${var.prefix}-vpc-subnet-0"
      subnet_ip     = "10.10.0.0/24"
      subnet_region = var.gcp_region
    }
  ]

  secondary_ranges = {
    "${var.prefix}-vpc-subnet-0" = [
      {
        range_name    = "${var.prefix}-subnet-0-pods"
        ip_cidr_range = "10.20.0.0/16"
      },
      {
        range_name    = "${var.prefix}-subnet-0-services"
        ip_cidr_range = "10.30.0.0/20"
      }
    ]
  }

  firewall_rules = [
    {
      name      = "${var.prefix}-egress-allow-all"
      direction = "EGRESS"
      priority  = 1000
      ranges    = ["0.0.0.0/0"]
      allow = [
        {
          protocol = "all"
        }
      ]
    },
    {
      name      = "${var.prefix}-ingress-lb-http-https-nodeports"
      direction = "INGRESS"
      priority  = 900
      ranges    = ["0.0.0.0/0"]
      allow = [
        {
          protocol = "tcp"
          ports    = ["80", "443", "30000-32767"]
        }
      ]
    }
  ]
}

module "cloud_router" {
  source  = "terraform-google-modules/cloud-router/google"
  version = "~> 6.2"

  project = var.gcp_project_id
  region  = var.gcp_region
  name    = "${var.prefix}-router"
  network = module.vpc.network_name

  nats = [
    {
      name                               = "${var.prefix}-nat"
      nat_ip_allocate_option             = "AUTO_ONLY"
      source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
    }
  ]
}

module "gke" {
  source  = "terraform-google-modules/kubernetes-engine/google"
  version = "~> 36.0"

  project_id = var.gcp_project_id
  name       = "${var.prefix}-gke"
  region     = var.gcp_region

  network           = module.vpc.network_name
  subnetwork        = module.vpc.subnets["${var.gcp_region}/${var.prefix}-vpc-subnet-0"].name
  ip_range_pods     = "${var.prefix}-subnet-0-pods"
  ip_range_services = "${var.prefix}-subnet-0-services"

  release_channel     = "REGULAR"
  deletion_protection = false

  remove_default_node_pool = true
  initial_node_count       = 1

  node_pools = [
    {
      name               = "${var.prefix}-node-pool"
      machine_type       = var.gke_machine_type
      disk_size_gb       = var.gke_disk_size_gb
      initial_node_count = var.gke_initial_node_count
      min_count          = var.gke_min_nodes
      max_count          = var.gke_max_nodes
      auto_repair        = true
      auto_upgrade       = true
    }
  ]

  node_pools_oauth_scopes = {
    all = ["https://www.googleapis.com/auth/cloud-platform"]
  }
}
