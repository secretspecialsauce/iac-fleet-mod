terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
}

module "service_accounts" {
  source = "./submodules/cluster_service_accounts"

  cluster_name                           = var.cluster_name
  gsa_project_id                         = var.gsa_project_id
  secret_project_id                      = var.secret_project_id
  gsa_gcr_agent_iam_project              = var.gsa_gcr_agent_iam_project
  gsa_abm_gke_connect_agent_iam_project  = var.gsa_abm_gke_connect_agent_iam_project
  gsa_abm_gke_register_agent_iam_project = var.gsa_abm_gke_register_agent_iam_project
  gsa_acm_monitoring_agent_iam_project   = var.gsa_acm_monitoring_agent_iam_project
  gsa_abm_ops_agent_iam_project          = var.gsa_abm_ops_agent_iam_project
  gsa_external_secrets_iam_project       = var.gsa_external_secrets_iam_project
  gsa_sds_backup_agent_iam_project       = var.gsa_sds_backup_agent_iam_project
  gsa_gateway_connect_agent_iam_project  = var.gsa_gateway_connect_agent_iam_project
  gsa_cdi_import_agent_iam_project       = var.gsa_cdi_import_agent_iam_project
  gsa_storage_agent_iam_project          = var.gsa_storage_agent_iam_project
  # TODO add target machine when ready
  # gsa_target_machine_iam_project         = var.gsa_target_machine_iam_project
}

module "sds_backup" {
  source = "./submodules/cluster_sds_backup"

  cluster_name            = var.cluster_name
  bucket_location         = var.sds_bucket_location
  project_id              = var.sds_project_id
  bucket_service_account  = module.service_accounts.sds_gsa.email
  prefix                  = var.sds_bucket_prefix
  service_account_project = var.gsa_project_id
  secret_project          = var.secret_project_id
}

# Create snapshot bucket
resource "google_storage_bucket" "snapshot" {
  location                    = var.snapshot_bucket_location
  project                     = var.fleet_project_id
  name                        = "${var.fleet_project_id}-cluster-snapshots"
  force_destroy               = false
  uniform_bucket_level_access = true
}

# placeholder for target machine GSA
#data "google_iam_policy" "snapshot" {
#  binding {
#    role    = "roles/storage.objectAdmin"
#    members = ["serviceAccount:${var.snapshot_bucket_gsa_email}"]
#  }
#}
#
#resource "google_storage_bucket_iam_policy" "policy" {
#  bucket      = google_storage_bucket.snapshot.name
#  policy_data = data.google_iam_policy.default.policy_data
#}
