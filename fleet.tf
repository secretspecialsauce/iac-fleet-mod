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

  project_id                             = module.fleet_project.name
  network_name                           = "${module.fleet_project.name}-fleet-vpc" 
  delete_default_internet_gateway_routes = true

  subnets = var.fleet_vpc_subnets
  secondary_ranges = local.restricted_vpc_secondary_ranges
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

module "vm_compute_instance_factory" {
  source  = "terraform-google-modules/vm/google//modules/compute_instance"
  version = "7.8.0"

  for_each           = module.vm_instance_template
  instance_template  = each.value.self_link
  region             = data.terraform_remote_state.project_factory.outputs.projects[each.key].region
  num_instances      = var.REQUIRED_CLUSTER_SIZE
  subnetwork_project = data.terraform_remote_state.project_factory.outputs.host_projects.project_id
  hostname           = var.hostname_prefix
}

module "vpn_ha" {
  source                = "terraform-google-modules/vpn/google//modules/vpn_ha"
  version               = "2.2.0"

  project_id            = module.base_network_vpc.project_id
  region                = var.vpn_region
  network               = module.base_network_vpc.network_name
  name                  = var.vpn_name
  peer_external_gateway = {
    redundancy_type = "TWO_IPS_REDUNDANCY"
    interfaces = [
      {
        id         = 0
        ip_address = var.secondary_onprem_ip # on-prem router ip address
      },
      {
        id         = 1
        ip_address = var.primary_onprem_ip # on-prem router ip address
      }
    ]
  }
  router_asn = 64514
  tunnels = {
    remote-0 = {
      bgp_peer = {
        address = "169.254.1.1"
        asn     = 64513
      }
      bgp_peer_options                = null
      bgp_session_range               = "169.254.1.2/30"
      ike_version                     = 2
      vpn_gateway_interface           = 0
      peer_external_gateway_interface = 0
      shared_secret                   = var.shared_secret_1
    }
    remote-1 = {
      bgp_peer = {
        address = "169.254.2.1"
        asn     = 64513
      }
      bgp_peer_options                = null
      bgp_session_range               = "169.254.2.2/30"
      ike_version                     = 2
      vpn_gateway_interface           = 1
      peer_external_gateway_interface = 0
      shared_secret                   = var.shared_secret_2
    }
  }
}