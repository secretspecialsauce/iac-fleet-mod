# Create snapshot bucket and grant IAM perms to storage GSA
resource "google_storage_bucket" "snapshot" {
  location                    = var.snapshot_bucket_location
  project                     = var.fleet_project_id
  name                        = "${var.fleet_project_id}-${var.cluster_name}-snapshot"
  force_destroy               = false
  uniform_bucket_level_access = true
}

data "google_iam_policy" "snapshot" {
  binding {
    role    = "roles/storage.objectAdmin"
    members = ["serviceAccount:${module.service_accounts.storage_gsa.email}"]
  }
}

resource "google_storage_bucket_iam_policy" "policy" {
  bucket      = google_storage_bucket.snapshot.name
  policy_data = data.google_iam_policy.snapshot.policy_data
}
