resource "google_project_service" "container" {
  service            = "container.googleapis.com"
  disable_on_destroy = false
}

resource "google_service_account" "gke_nodes" {
  account_id   = "${var.prefix}-gke-nodes"
  display_name = "GKE node pool (${var.prefix})"
}

resource "google_project_iam_member" "gke_nodes_logging" {
  project = var.gcp_project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.gke_nodes.email}"
}

resource "google_project_iam_member" "gke_nodes_monitoring" {
  project = var.gcp_project_id
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_service_account.gke_nodes.email}"
}

resource "google_project_iam_member" "gke_nodes_artifact_registry" {
  project = var.gcp_project_id
  role    = "roles/artifactregistry.reader"
  member  = "serviceAccount:${google_service_account.gke_nodes.email}"
}

resource "google_container_cluster" "this" {
  name     = "${var.prefix}-gke"
  location = var.gcp_region

  network    = "${var.new-vpc-name}"
  subnetwork = "${var.subnetwork-primary-name}"

  remove_default_node_pool = true
  initial_node_count       = 1

  ip_allocation_policy {
    cluster_secondary_range_name  = "${var.prefix}-subnet-0-pods"
    services_secondary_range_name = "${var.prefix}-subnet-0-services"
  }

  workload_identity_config {
    workload_pool = "${var.gcp_project_id}.svc.id.goog"
  }

  release_channel {
    channel = "REGULAR"
  }

  deletion_protection = false

  depends_on = [
    google_project_service.container,
  ]
}

resource "google_container_node_pool" "primary" {
  name     = "${var.prefix}-node-pool"
  location = var.gcp_region
  cluster  = google_container_cluster.this.id

  initial_node_count = var.gke_initial_node_count

  autoscaling {
    min_node_count = var.gke_min_nodes
    max_node_count = var.gke_max_nodes
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  node_config {
    machine_type    = var.gke_machine_type
    disk_size_gb    = var.gke_disk_size_gb
    service_account = google_service_account.gke_nodes.email
    oauth_scopes    = ["https://www.googleapis.com/auth/cloud-platform"]

    workload_metadata_config {
      mode = "GKE_METADATA"
    }
  }

  depends_on = [
    google_project_iam_member.gke_nodes_logging,
    google_project_iam_member.gke_nodes_monitoring,
    google_project_iam_member.gke_nodes_artifact_registry,
  ]
}

output "gke_cluster_name" {
  description = "Nome do cluster GKE."
  value       = google_container_cluster.this.name
}

output "gke_cluster_endpoint" {
  description = "Endpoint da API do Kubernetes (use com kubectl após credenciais)."
  value       = google_container_cluster.this.endpoint
  sensitive   = true
}

output "gke_node_service_account" {
  description = "Service account dos nós (Terraform precisa de iam.serviceAccountUser nela ao aplicar)."
  value       = google_service_account.gke_nodes.email
}

output "gcp_region" {
  description = "Região do cluster (para gcloud get-credentials)."
  value       = var.gcp_region
}

output "gcp_project_id" {
  description = "ID do projeto (para gcloud get-credentials)."
  value       = var.gcp_project_id
}
