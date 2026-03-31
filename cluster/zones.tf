data "google_compute_zones" "get-all-zones" {
  region = var.gcp_region
}

output "gcp_availability_zones" {
  description = "Nomes das zonas de disponibilidade Compute Engine na região gcp_region."
  value       = data.google_compute_zones.get-all-zones.names
}
