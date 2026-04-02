variable "gcp_project_id" {
  description = "ID do projeto GCP em texto (Console → seletor de projeto). Obrigatório ser o string id (ex. my-proj), não o número — GKE Workload Identity exige isso."
  type        = string
}

variable "gcp_region" {
  description = "GCP region"
  type        = string
}

variable "prefix" {
  description = "Prefix for the resources"
  type        = string
  default     = "new"
}

variable "gke_machine_type" {
  description = "Machine type dos nós do pool principal."
  type        = string
  default     = "e2-medium"
}

variable "gke_disk_size_gb" {
  description = "Disco boot por nó (GB)."
  type        = number
  default     = 50
}

variable "gke_initial_node_count" {
  description = "Nós no primeiro apply (autoscaling ajusta depois)."
  type        = number
  default     = 1
}

variable "gke_min_nodes" {
  description = "Mínimo de nós no pool."
  type        = number
  default     = 1
}

variable "gke_max_nodes" {
  description = "Máximo de nós no pool."
  type        = number
  default     = 3
}

variable "new-vpc-name" {
  description = "Nome da nova VPC"
  type        = string
}

variable "subnetwork-primary-name" {
  description = "Nome da subnetwork principal"
  type        = string
}