# Deprecating the below IaC which loops over data structure defined in main.tf
# It was deprecated because project_id is passed in as a variable from project creation
# in previous step, and as project IDs are generated dynamically, no longer works with for_each.
# However because the implementation was nontrivially complex and not obvious using the flatten + split
# functions, I am keeping it here in case it proves useful in a future where project_ids
# (to which IAM permissions are assigned on a per-SA-per-project basis) are defined statically.
## begin deprecated dynamic GSA + IAM resource creation
#resource "google_service_account" "default" {
#  for_each = local.service_accounts
#
#  project = var.gsa_project_id
#
#  account_id   = each.key
#  display_name = each.value.description
#}
#
#resource "google_project_iam_member" "default" {
#  for_each = toset(flatten([
#    for gsa, gsa_cfg in local.service_accounts : [
#      for role in gsa_cfg.roles : "${gsa}=>${role}=>${gsa_cfg.project_id}"
#    ]
#  ]))
#
#  member  = "serviceAccount:${google_service_account.default[split("=>", each.value)[0]].email}"
#  project = split("=>", each.value)[2]
#  role    = split("=>", each.value)[1]
#
#  depends_on = [google_service_account.default]
#}
### end deprecated looping IaC

# Creates all SAs
resource "google_service_account" "default" {
  for_each = local.service_accounts

  project = var.gsa_project_id

  account_id   = each.key
  display_name = each.key
  description  = each.value.description
}

## Begin IAM permissions for GSAs
resource "google_project_iam_member" "abm-gcr" {
  for_each = toset(local.service_accounts["abm-gcr-${var.cluster_name}"].roles)

  member  = "serviceAccount:${google_service_account.default["abm-gcr-${var.cluster_name}"].email}"
  role    = each.value
  project = local.service_accounts["abm-gcr-${var.cluster_name}"].project_id
}

resource "google_project_iam_member" "abm-gke-con" {
  for_each = toset(local.service_accounts["abm-gke-con-${var.cluster_name}"].roles)

  member  = "serviceAccount:${google_service_account.default["abm-gke-con-${var.cluster_name}"].email}"
  role    = each.value
  project = local.service_accounts["abm-gke-con-${var.cluster_name}"].project_id
}

resource "google_project_iam_member" "abm-gke-reg" {
  for_each = toset(local.service_accounts["abm-gke-reg-${var.cluster_name}"].roles)

  member  = "serviceAccount:${google_service_account.default["abm-gke-reg-${var.cluster_name}"].email}"
  role    = each.value
  project = local.service_accounts["abm-gke-reg-${var.cluster_name}"].project_id
}

resource "google_project_iam_member" "acm-mon" {
  for_each = toset(local.service_accounts["acm-mon-${var.cluster_name}"].roles)

  member  = "serviceAccount:${google_service_account.default["acm-mon-${var.cluster_name}"].email}"
  role    = each.value
  project = local.service_accounts["acm-mon-${var.cluster_name}"].project_id
}

resource "google_project_iam_member" "abm-ops" {
  for_each = toset(local.service_accounts["abm-ops-${var.cluster_name}"].roles)

  member  = "serviceAccount:${google_service_account.default["abm-gke-reg-${var.cluster_name}"].email}"
  role    = each.value
  project = local.service_accounts["abm-ops-${var.cluster_name}"].project_id
}

resource "google_project_iam_member" "es-k8s" {
  for_each = toset(local.service_accounts["es-k8s-${var.cluster_name}"].roles)

  member  = "serviceAccount:${google_service_account.default["es-k8s-${var.cluster_name}"].email}"
  role    = each.value
  project = local.service_accounts["es-k8s-${var.cluster_name}"].project_id
}

resource "google_project_iam_member" "sds-backup" {
  for_each = toset(local.service_accounts["sds-backup-${var.cluster_name}"].roles)

  member  = "serviceAccount:${google_service_account.default["sds-backup-${var.cluster_name}"].email}"
  role    = each.value
  project = local.service_accounts["sds-backup-${var.cluster_name}"].project_id
}

resource "google_project_iam_member" "gtw-con" {
  for_each = toset(local.service_accounts["gtw-con-${var.cluster_name}"].roles)

  member  = "serviceAccount:${google_service_account.default["gtw-con-${var.cluster_name}"].email}"
  role    = each.value
  project = local.service_accounts["gtw-con-${var.cluster_name}"].project_id
}

resource "google_project_iam_member" "cdi-import" {
  for_each = toset(local.service_accounts["cdi-import-${var.cluster_name}"].roles)

  member  = "serviceAccount:${google_service_account.default["cdi-import-${var.cluster_name}"].email}"
  role    = each.value
  project = local.service_accounts["cdi-import-${var.cluster_name}"].project_id
}

resource "google_project_iam_member" "storage" {
  for_each = toset(local.service_accounts["storage-${var.cluster_name}"].roles)

  member  = "serviceAccount:${google_service_account.default["storage-${var.cluster_name}"].email}"
  role    = each.value
  project = local.service_accounts["storage-${var.cluster_name}"].project_id
}
## End IAM for GSAs

resource "google_service_account_key" "default" {
  for_each = local.service_accounts

  service_account_id = google_service_account.default[each.key].name
}

resource "google_secret_manager_secret" "default" {
  for_each = local.service_accounts

  project   = var.secret_project_id
  secret_id = each.key

  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "default" {
  for_each = local.service_accounts

  secret = google_secret_manager_secret.default[each.key].id

  secret_data = base64decode(google_service_account_key.default[each.key].private_key)
}