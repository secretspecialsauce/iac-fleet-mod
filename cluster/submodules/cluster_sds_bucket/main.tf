terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
}

resource "google_storage_bucket" "default" {
  project       = var.project_id
  name          = "${var.prefix}-fleet-sds-bucket-${var.cluster_name}"
  location      = var.bucket_location
  force_destroy = false

  uniform_bucket_level_access = true
}

data "google_iam_policy" "default" {
  binding {
    role    = "roles/storage.admin"
    members = var.bucket_service_accounts
  }
}

resource "google_storage_bucket_iam_policy" "policy" {
  bucket      = google_storage_bucket.default.name
  policy_data = data.google_iam_policy.default.policy_data
}
