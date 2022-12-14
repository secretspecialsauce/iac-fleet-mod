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


module "sds_bucket" {
  source = "./submodules/cluster_sds_bucket"

  cluster_name            = var.cluster_name
  bucket_location         = "us-central1"
  project_id              = var.sds_project_id
  bucket_service_accounts = concat(["serviceAccount:${module.service_accounts.sds_gsa.email}"], var.sds_bucket_service_accounts)
}
