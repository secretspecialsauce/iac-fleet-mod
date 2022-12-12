terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
}

module "service_accounts" {
  source = "./modules/cluster_service_accounts"
}

