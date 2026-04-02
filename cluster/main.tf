module "new-vpc" {
  source     = "./modules/vpc"
  gcp_region = var.gcp_region
  prefix     = var.prefix
}

module "new-gke-cluster" {
  source     = "./modules/gke"
  gcp_region = var.gcp_region
  prefix     = var.prefix
  gcp_project_id = var.gcp_project_id
  gke_machine_type = var.gke_machine_type
  gke_disk_size_gb = var.gke_disk_size_gb
  gke_initial_node_count = var.gke_initial_node_count
  gke_min_nodes = var.gke_min_nodes
  gke_max_nodes = var.gke_max_nodes

  new-vpc-name = module.new-vpc.new-vpc-name
  subnetwork-primary-name = module.new-vpc.subnetwork-primary-name
}