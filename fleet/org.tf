// Anthos Fleet Deployment Project
// folder to contain fleet control plane folders and their associated projects
resource "google_folder" "fleet_control_plane" {
  display_name = "fleet-control-plane"
  parent       = google_folder.fleet.name
}

// below folders nest under fleet-control-plane
// fleet control plane folder for security projects
resource "google_folder" "fleet_control_plane_security" {
  display_name = "security"
  parent       = google_folder.fleet_control_plane.name
}

// fleet control plane folder for network projects
resource "google_folder" "fleet_control_plane_platform" {
  display_name = "platform"
  parent       = google_folder.fleet_control_plane.name
}

// fleet control plane folder for observability projects
resource "google_folder" "fleet_control_plane_observability" {
  display_name = "observability"
  parent       = google_folder.fleet_control_plane.name
}

// below projects nest under their associated control plane folder
// Enterprise Security Projects
module "control_plane_secrets_project" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 10.1"

  name              = "${local.project_prefix}secrets"
  random_project_id = true
  org_id            = var.org_id
  folder_id         = google_folder.fleet_control_plane_security.name
  billing_account   = var.billing_account_id

  activate_apis = [
    "cloudbilling.googleapis.com",
    "secretmanager.googleapis.com",
    "cloudkms.googleapis.com"
  ]
}

module "control_plane_service_account_project" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 10.1"

  name              = "${local.project_prefix}svc-accts"
  random_project_id = true
  org_id            = var.org_id
  folder_id         = google_folder.fleet_control_plane_security.name
  billing_account   = var.billing_account_id

  activate_apis = local.edge_enable_services
}


module "control_plane_observability_project" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 10.1"

  name              = "${local.project_prefix}observability"
  random_project_id = true
  org_id            = var.org_id
  folder_id         = google_folder.fleet_control_plane_observability.name
  billing_account   = var.billing_account_id

  activate_apis = [
    "cloudbilling.googleapis.com",
    "monitoring.googleapis.com",
    "logging.googleapis.com"
  ]
}

module "control_plane_networking_project" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 10.1"

  name              = "${local.project_prefix}network"
  random_project_id = true
  org_id            = var.org_id
  folder_id         = google_folder.fleet_control_plane_platform.name
  billing_account   = var.billing_account_id

  activate_apis = [
    "cloudbilling.googleapis.com",
    "compute.googleapis.com"
  ]
}

module "fleet_project" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 10.1"

  name              = "${local.project_prefix}fleet-${var.fleet_name}"
  random_project_id = true
  org_id            = var.org_id
  folder_id         = google_folder.fleet.name
  billing_account   = var.billing_account_id

  activate_apis = local.edge_enable_services
}
