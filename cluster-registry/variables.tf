variable "gcp_project_id" {
  description = "ID do projeto GCP (string id, ex. my-proj)."
  type        = string
}

variable "gcp_region" {
  description = "Regiao GCP."
  type        = string
}

variable "prefix" {
  description = "Prefixo para nomear recursos."
  type        = string
  default     = "new"
}

variable "gke_machine_type" {
  description = "Machine type dos nos do pool principal."
  type        = string
  default     = "e2-medium"
}

variable "gke_disk_size_gb" {
  description = "Disco boot por no (GB)."
  type        = number
  default     = 50
}

variable "gke_initial_node_count" {
  description = "Nos no primeiro apply."
  type        = number
  default     = 1
}

variable "gke_min_nodes" {
  description = "Minimo de nos no pool."
  type        = number
  default     = 1
}

variable "gke_max_nodes" {
  description = "Maximo de nos no pool."
  type        = number
  default     = 3
}
