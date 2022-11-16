terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
    }
  }
}

// create a folder that houses the fleet control plane and the fleet project. This folder should attach to a region folder.
resource "google_folder" "fleet" {
  display_name = var.fleet_folder_name
  parent       = var.region_folder_name
}
