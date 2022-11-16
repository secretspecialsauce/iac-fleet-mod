resource "google_compute_router_interface" "router1_interface1" {
  project    = var.project_id
  name       = "${var.cluster_name}-interface1"
  router     = var.router
  region     = var.region
  ip_range   = var.router_ips.interface1.ip_range
  vpn_tunnel = var.tunnels["tunnel0"].id
}

resource "google_compute_router_peer" "router1_peer1" {
  project                   = var.project_id
  name                      = "${var.cluster_name}-peer1"
  router                    = var.router
  region                    = var.region
  peer_ip_address           = var.router_ips.interface1.peer_ip
  peer_asn                  = var.peer_asn
  advertised_route_priority = 100
  interface                 = google_compute_router_interface.router1_interface1.name
}

resource "google_compute_router_interface" "router1_interface2" {
  project    = var.project_id
  name       = "${var.cluster_name}-interface2"
  router     = var.router
  region     = var.region
  ip_range   = var.router_ips.interface2.ip_range
  vpn_tunnel = var.tunnels["tunnel1"].id
}


resource "google_compute_router_peer" "router1_peer2" {
  project                   = var.project_id
  name                      = "${var.cluster_name}-peer2"
  router                    = var.router
  region                    = var.region
  peer_ip_address           = var.router_ips.interface2.peer_ip
  peer_asn                  = var.peer_asn
  advertised_route_priority = 100
  interface                 = google_compute_router_interface.router1_interface2.name
}
