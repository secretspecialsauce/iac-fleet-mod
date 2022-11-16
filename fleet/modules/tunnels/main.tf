variable "cluster_name" {}
variable "project_id" {}
variable "region" {}
variable "router" {}
variable "vpn_gw" {}
variable "peer_gw" {}
variable "shared_secret" {}

resource "google_compute_vpn_tunnel" "tunnel0" {
  project                         = var.project_id
  name                            = "${var.cluster_name}-tunnel0"
  region                          = var.region
  vpn_gateway                     = var.vpn_gw
  peer_external_gateway           = var.peer_gw
  peer_external_gateway_interface = 0
  shared_secret                   = var.shared_secret
  router                          = var.router
  vpn_gateway_interface           = 0
}



resource "google_compute_vpn_tunnel" "tunnel1" {
  project                         = var.project_id
  name                            = "${var.cluster_name}-tunnel1"
  region                          = var.region
  vpn_gateway                     = var.vpn_gw
  peer_external_gateway           = var.peer_gw
  peer_external_gateway_interface = 1
  shared_secret                   = var.shared_secret
  router                          = var.router
  vpn_gateway_interface           = 1
}

output "tunnel0" {
  value = google_compute_vpn_tunnel.tunnel0
}

output "tunnel1" {
  value = google_compute_vpn_tunnel.tunnel1
}
