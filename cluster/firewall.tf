
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

# LoadBalancer (Service type LoadBalancer) encaminha para NodePorts nos nós. Sem ingress
# permitido, o IP externo pode dar timeout. Sem target_tags aplica a todas as VMs desta VPC.
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

# locals {
#   # Cobre as duas subnets 10.10.0.0/24 e 10.10.1.0/24 (ajuste se mudar vpc.tf).
#   vpc_internal_cidr = "10.10.0.0/23"
# }

# resource "google_compute_firewall" "ingress_allow_vpc_internal" {
#   name      = "${var.prefix}-ingress-vpc-internal-only"
#   network   = google_compute_network.new-vpc.name
#   direction = "INGRESS"
#   priority  = 1000

#   source_ranges = [local.vpc_internal_cidr]

#   allow {
#     protocol = "all"
#   }
# }

# Exemplo (descomente e remova/ajuste egress_allow_all se quiser egress restrito):
# Firewall VPC é L4 por IP/CIDR — não filtra por nome de site (FQDN). Use o IP do destino
# ou Firewall Policy / outros produtos para FQDN.
#
# resource "google_compute_firewall" "egress_https_site_x_example" {
#   name      = "${var.prefix}-egress-https-site-x-only"
#   network   = google_compute_network.new-vpc.name
#   direction = "EGRESS"
#   priority  = 900
#
#   destination_ranges = ["198.51.100.10/32"]
#
#   allow {
#     protocol = "tcp"
#     ports    = ["443"]
#   }
# }
#
# Para “só o site X” na prática costuma-se combinar com negação do restante (ex. política
# hierárquica) ou não declarar egress amplo — um desenho por vez.

# Quando expuser o Ingress Controller (ex.: nginx), crie uma regra INGRESS com prioridade
# menor que 1000 (ex.: 900) permitindo só o necessário, por exemplo:
#
# resource "google_compute_firewall" "ingress_http_https_from_internet_example" {
#   name      = "${var.prefix}-ingress-lb-http-https"
#   network   = google_compute_network.new-vpc.name
#   direction = "INGRESS"
#   priority  = 900
#
#   source_ranges = ["0.0.0.0/0"]
#
#   allow {
#     protocol = "tcp"
#     ports    = ["80", "443"]
#   }
#
#   target_tags = ["seu-tag-dos-nodes-ou-lb"]
# }
