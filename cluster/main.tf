terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
}

module "service_accounts" {
  source = "./submodules/cluster_service_accounts"

  cluster_name             = var.cluster_name
  fleet_project_id         = var.fleet_project_id
  gsa_project_id           = var.gsa_project_id
  secrets_project_id       = var.secrets_project_id
  observability_project_id = var.observability_project_id
  network_project_id       = var.network_project_id
  sds_project_id           = var.sds_project_id
}

module "sds_backup" {
  source = "./submodules/cluster_sds_backup"

  cluster_name            = var.cluster_name
  bucket_location         = var.sds_bucket_location
  project_id              = var.sds_project_id
  bucket_service_account  = module.service_accounts.sds_gsa.email
  prefix                  = var.sds_bucket_prefix
  service_account_project = var.gsa_project_id
  secret_project          = var.secrets_project_id
}
