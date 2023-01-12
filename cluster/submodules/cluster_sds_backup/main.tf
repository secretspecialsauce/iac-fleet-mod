terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
}

resource "google_storage_bucket" "default" {
  project       = var.project_id
  name          = "${var.project_id}-${var.cluster_name}-sds-backup"
  location      = var.bucket_location
  force_destroy = false

  uniform_bucket_level_access = true
}

data "google_iam_policy" "default" {
  binding {
    role    = "roles/storage.admin"
    members = ["serviceAccount:${var.bucket_service_account}"]
  }
}

resource "google_storage_bucket_iam_policy" "policy" {
  bucket      = google_storage_bucket.default.name
  policy_data = data.google_iam_policy.default.policy_data
}

#Create the HMAC key for the associated service account
resource "google_storage_hmac_key" "default" {
  service_account_email = var.bucket_service_account
  project               = var.service_account_project
}

# Create secret for HMAC key
resource "google_secret_manager_secret" "hmac" {
  project   = var.secret_project
  secret_id = "${var.project_id}-${var.cluster_name}-sds-hmac-secret"

  replication {
    automatic = true
  }
}

# Create secret version with JSON-encoded key for Longhorn
resource "google_secret_manager_secret_version" "hmac" {
  secret = google_secret_manager_secret.hmac.id
  secret_data = jsonencode({
    "access_key" : google_storage_hmac_key.default.access_id,
    "access_secret" : google_storage_hmac_key.default.secret,
    "endpoint" : "https://storage.googleapis.com"
  })
}