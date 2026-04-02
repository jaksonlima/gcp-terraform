output "gcp_availability_zones" {
  description = "Nomes das zonas de disponibilidade Compute Engine na região gcp_region."
  value       = data.google_compute_zones.get-all-zones.names
}


output "new-vpc-name" {
  description = "Nome da nova VPC"
  value       = google_compute_network.new-vpc.name
}

output "subnetwork-primary-name" {
  description = "Nome da subnetwork principal"
  value       = google_compute_subnetwork.primary.name
}