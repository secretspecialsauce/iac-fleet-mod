// Anthos Fleet Deployment Project
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
