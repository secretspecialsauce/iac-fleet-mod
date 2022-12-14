output "storage_gsa" {
  value = google_service_account.default["storage-${var.cluster_name}"]
}

output "sds_gsa" {
  value = google_service_account.default["sds-backup-${var.cluster_name}"]
}