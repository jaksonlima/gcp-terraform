output "network_name" {
  description = "Nome da VPC."
  value       = module.vpc.network_name
}

output "cluster_name" {
  description = "Nome do cluster GKE."
  value       = module.gke.name
}

output "cluster_endpoint" {
  description = "Endpoint da API do Kubernetes."
  value       = module.gke.endpoint
  sensitive   = true
}

output "service_account" {
  description = "Service account dos nos do GKE."
  value       = module.gke.service_account
}
