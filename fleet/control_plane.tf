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
resource "google_folder" "fleet_control_plane_network" {
  display_name = "network"
  parent       = google_folder.fleet_control_plane.name
}

// fleet control plane folder for observability projects
resource "google_folder" "fleet_control_plane_observability" {
  display_name = "observability"
  parent       = google_folder.fleet_control_plane.name
}

// below projects nets under their associated control plane folder
// Enterprise Security Projects
module "control_plane_kms_project" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 10.1"

  name              = "${local.project_prefix}kms-prj"
  random_project_id = true
  org_id            = var.org_id
  folder_id         = google_folder.fleet_control_plane_security.name
  billing_account   = var.billing_account_id

  activate_apis = [
    "cloudbilling.googleapis.com",
  ]
}


module "control_plane_secret_manager_project" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 10.1"

  name              = "${local.project_prefix}secrets"
  random_project_id = true
  org_id            = var.org_id
  folder_id         = google_folder.fleet_control_plane_security.name
  billing_account   = var.billing_account_id

  activate_apis = [
    "cloudbilling.googleapis.com",
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

// Enterprise Networking Projects
module "control_plane_networking_project" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 10.1"

  name              = "${local.project_prefix}network"
  random_project_id = true
  org_id            = var.org_id
  folder_id         = google_folder.fleet_control_plane_network.name
  billing_account   = var.billing_account_id

  activate_apis = [
    "cloudbilling.googleapis.com",
  ]
}

// Observability Projects
module "control_plane_logs_project" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 10.1"

  name              = "${local.project_prefix}logs"
  random_project_id = true
  org_id            = var.org_id
  folder_id         = google_folder.fleet_control_plane_observability.name
  billing_account   = var.billing_account_id

  activate_apis = [
    "cloudbilling.googleapis.com",
  ]
}

module "control_plane_monitoring_project" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 10.1"

  name              = "${local.project_prefix}monitoring"
  random_project_id = true
  org_id            = var.org_id
  folder_id         = google_folder.fleet_control_plane_observability.name
  billing_account   = var.billing_account_id

  activate_apis = [
    "cloudbilling.googleapis.com",
  ]
}
