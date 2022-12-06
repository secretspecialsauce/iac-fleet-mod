// Anthos Fleet Deployment Project
module "fleet_project" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 10.1"

  name              = var.fleet_name
  random_project_id = true
  org_id            = var.org_id
  folder_id         = google_folder.fleet.name
  billing_account   = var.billing_account_id

  activate_apis = [
    "cloudbilling.googleapis.com",
  ]
}

module "fleet_vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 5.1.0"

  project_id                             = module.fleet_network_project
  network_name                           = "${module.fleet_project.name}-fleet-vpc"
  routing_mode = "REGIONAL"

  delete_default_internet_gateway_routes = true

  subnets = [var.fleet_subnet]
  # secondary_ranges = local.restricted_vpc_secondary_ranges
}

module "fleet_service_accounts" {
  source  = "terraform-google-modules/service-accounts/google"
  version = "~> 4.0"

  for_each     = var.clusters

  project_id   = var.fleet_name
  names        = [each.value.cluster_name]
  display_name = "CNUCs Service Account - Terraform managed"

  project_roles = [
    "${each.key}=>roles/gkehub.connect",
    "${each.key}=>roles/gkehub.admin",
    "${each.key}=>roles/logging.logWriter",
    "${each.key}=>roles/monitoring.metricWriter",
    "${each.key}=>roles/monitoring.dashboardEditor",
    "${each.key}=>roles/stackdriver.resourceMetadata.writer",
    "${each.key}=>roles/opsconfigmonitoring.resourceMetadata.writer",
  ]
}

resource "google_compute_router" "fleet-router" {
  name    = "edge-fleet-${var.fleet_subnet.subnet_region}"
  region  = var.fleet_subnet.subnet_region
  network = module.vpc.network_id
  project = var.fleet_network_project

  bgp {
    asn = "64519"
  }
}

variable "vpn_peers" {
  default = {
    "cluster0" = {
      peer_ips      = ["8.8.8.8", "8.8.4.4"]
      shared_secret = "foobarbazquux"
      router_ips = {
        interface1 = {
          ip_range = "169.254.0.1/30"
          peer_ip  = "169.254.0.2"
        }
        interface2 = {
          ip_range = "169.254.1.1/30"
          peer_ip  = "169.254.1.2"
        }
      }
    }
    "cluster1" = {
      peer_ips      = ["1.1.1.1", "1.0.0.1"]
      shared_secret = "foobarbazquux"
      router_ips = {
        interface1 = {
          ip_range = "169.254.2.1/30"
          peer_ip  = "169.254.2.2"
        }
        interface2 = {
          ip_range = "169.254.3.1/30"
          peer_ip  = "169.254.3.2"
        }
      }
    }
  }
}

resource "google_compute_ha_vpn_gateway" "ha_gateway" {
  project = var.fleet_network_project
  region  = "us-central1"
  name    = "fleet-gw-us-central1"
  network = module.vpc.network_id
}

resource "google_compute_external_vpn_gateway" "peer" {
  for_each = var.vpn_peers

  project         = var.fleet_network_project
  name            = each.key
  redundancy_type = "TWO_IPS_REDUNDANCY"
  description     = "An externally managed VPN gateway"
  dynamic "interface" {
    for_each = each.value.peer_ips
    content {
      id         = interface.key
      ip_address = interface.value
    }
  }
}

output "peers" {
  value = google_compute_external_vpn_gateway.peer
}

module "tunnels" {
  source = "./tunnels"

  for_each = var.vpn_peers

  cluster_name  = each.key
  project_id    = var.fleet_network_project
  region        = "us-central1"
  router        = google_compute_router.fleet-router.id
  vpn_gw        = google_compute_ha_vpn_gateway.ha_gateway.id
  peer_gw       = google_compute_external_vpn_gateway.peer[each.key].id
  shared_secret = each.value.shared_secret
}

module "bgp" {
  source = "./bgp"

  for_each = var.vpn_peers

  cluster_name = each.key
  project_id   = var.fleet_network_project
  region       = "us-central1"
  router       = google_compute_router.fleet-router.name
  tunnels      = module.tunnels[each.key]
  router_ips   = each.value.router_ips
}

module "vm_instance_template" {
  source  = "terraform-google-modules/vm/google//modules/instance_template"
  version = "7.9.0"

  for_each           = module.service_accounts
  
  project_id         = var.fleet_name
  service_account = { email = each.value.email,
    scopes = ["cloud-platform"]
  }

  name_prefix = each.key

  can_ip_forward       = var.ip_fwd
  disk_size_gb         = var.disk_size
  disk_type            = var.disk_type
  labels               = var.labels
  machine_type         = var.machine_type
  metadata             = merge(var.metadata, { cluster_id = each.key, startup-script-url = "gs://abm-edge-boot-${each.key}/gce-init.sh" })
  min_cpu_platform     = var.min_cpu_platform
  source_image_family  = var.source_image_family
  source_image_project = var.source_image_project
  tags                 = var.tags
}

module "cluster_factory" {
  source  = "terraform-google-modules/vm/google//modules/compute_instance"
  version = "7.8.0"

  for_each           = module.vm_instance_template
  instance_template  = each.value.self_link
  region             = data.terraform_remote_state.project_factory.outputs.projects[each.key].region
  num_instances      = var.REQUIRED_CLUSTER_SIZE
  subnetwork_project = data.terraform_remote_state.project_factory.outputs.host_projects.project_id
  hostname           = var.hostname_prefix
}
