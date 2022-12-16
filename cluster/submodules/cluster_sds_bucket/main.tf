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

resource "google_secret_manager_secret" "hmac" {
  project   = var.secret_project
  secret_id = "sds-backup-${var.cluster_name}"

  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "hmac" {
  secret = google_secret_manager_secret.hmac.id
  secret_data = jsonencode({
    "access_key" : google_storage_hmac_key.default.access_id,
    "access_secret" : google_storage_hmac_key.default.secret,
    "endpoint" : "https://storage.googleapis.com"
  })
}