resource "google_compute_router_interface" "router1_interface1" {
  project    = var.project_id
  name       = "${var.cluster_name}-interface1"
  router     = var.router
  region     = var.region
  ip_range   = var.router_ifs.interface1.ip_range
  vpn_tunnel = var.tunnels["tunnel0"].id
}

resource "google_compute_router_peer" "router1_interface1_peer" {
  project                   = var.project_id
  name                      = "${var.cluster_name}-int1-peer1"
  router                    = var.router
  region                    = var.region
  peer_ip_address           = var.router_ifs.interface1.peer_ip
  peer_asn                  = var.router_ifs.interface1.peer_asn
  advertised_route_priority = 100
  interface                 = google_compute_router_interface.router1_interface1.name
}

resource "google_compute_router_interface" "router1_interface2" {
  project    = var.project_id
  name       = "${var.cluster_name}-interface2"
  router     = var.router
  region     = var.region
  ip_range   = var.router_ifs.interface2.ip_range
  vpn_tunnel = var.tunnels["tunnel1"].id
}


resource "google_compute_router_peer" "router1_interface2_peer" {
  project                   = var.project_id
  name                      = "${var.cluster_name}-int2-peer2"
  router                    = var.router
  region                    = var.region
  peer_ip_address           = var.router_ifs.interface2.peer_ip
  peer_asn                  = var.router_ifs.interface2.peer_asn
  advertised_route_priority = 100
  interface                 = google_compute_router_interface.router1_interface2.name
}
