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

### Resource pair, GSA and IAM roles for abm-gcr
resource "google_service_account" "abm-gcr" {
  project = var.gsa_project_id

  account_id   = "abm-gcr-${var.cluster_name}"
  display_name = "abm-gcr-${var.cluster_name}"
  description  = local.service_accounts["abm-gcr-${var.cluster_name}"].description
}

resource "google_project_iam_member" "abm-gcr" {
  for_each = toset(local.service_accounts["abm-gcr-${var.cluster_name}"].roles)

  member  = "serviceAccount:${google_service_account.abm-gcr.email}"
  role    = each.value
  project = local.service_accounts["abm-gcr-${var.cluster_name}"].project_id
}
### end pair

### Resource pair, GSA and IAM roles for abm-gke-con
resource "google_service_account" "abm-gke-con" {
  project = var.gsa_project_id

  account_id   = "abm-gke-con-${var.cluster_name}"
  display_name = "abm-gke-con-${var.cluster_name}"
  description  = local.service_accounts["abm-gke-con-${var.cluster_name}"].description
}

resource "google_project_iam_member" "abm-gke-con" {
  for_each = toset(local.service_accounts["abm-gke-con-${var.cluster_name}"].roles)

  member  = "serviceAccount:${google_service_account.abm-gke-con.email}"
  role    = each.value
  project = local.service_accounts["abm-gke-con-${var.cluster_name}"].project_id
}
### end pair

### Resource pair, GSA and IAM roles for abm-gke-reg
resource "google_service_account" "abm-gke-reg" {
  project = var.gsa_project_id

  account_id   = "abm-gke-reg-${var.cluster_name}"
  display_name = "abm-gke-reg-${var.cluster_name}"
  description  = local.service_accounts["abm-gke-reg-${var.cluster_name}"].description
}

resource "google_project_iam_member" "abm-gke-reg" {
  for_each = toset(local.service_accounts["abm-gke-reg-${var.cluster_name}"].roles)

  member  = "serviceAccount:${google_service_account.abm-gke-reg.email}"
  role    = each.value
  project = local.service_accounts["abm-gke-reg-${var.cluster_name}"].project_id
}
### end pair

### Resource pair, GSA and IAM roles for acm-mon
resource "google_service_account" "acm-mon" {
  project = var.gsa_project_id

  account_id   = "acm-mon-${var.cluster_name}"
  display_name = "acm-mon-${var.cluster_name}"
  description  = local.service_accounts["acm-mon-${var.cluster_name}"].description
}

resource "google_project_iam_member" "acm-mon" {
  for_each = toset(local.service_accounts["acm-mon-${var.cluster_name}"].roles)

  member  = "serviceAccount:${google_service_account.acm-mon.email}"
  role    = each.value
  project = local.service_accounts["acm-mon-${var.cluster_name}"].project_id
}
### end pair

### Resource pair, GSA and IAM roles for abm-ops
resource "google_service_account" "abm-ops" {
  project = var.gsa_project_id

  account_id   = "abm-ops-${var.cluster_name}"
  display_name = "abm-ops-${var.cluster_name}"
  description  = local.service_accounts["abm-ops-${var.cluster_name}"].description
}

resource "google_project_iam_member" "abm-ops" {
  for_each = toset(local.service_accounts["abm-ops-${var.cluster_name}"].roles)

  member  = "serviceAccount:${google_service_account.abm-ops.email}"
  role    = each.value
  project = local.service_accounts["abm-ops-${var.cluster_name}"].project_id
}
### end pair

### Resource pair, GSA and IAM roles for es-k8s
resource "google_service_account" "es-k8s" {
  project = var.gsa_project_id

  account_id   = "es-k8s-${var.cluster_name}"
  display_name = "es-k8s-${var.cluster_name}"
  description  = local.service_accounts["es-k8s-${var.cluster_name}"].description
}

resource "google_project_iam_member" "es-k8s" {
  for_each = toset(local.service_accounts["es-k8s-${var.cluster_name}"].roles)

  member  = "serviceAccount:${google_service_account.es-k8s.email}"
  role    = each.value
  project = local.service_accounts["es-k8s-${var.cluster_name}"].project_id
}
### end pair

### Resource pair, GSA and IAM roles for sds-backup
resource "google_service_account" "sds-backup" {
  project = var.gsa_project_id

  account_id   = "sds-backup-${var.cluster_name}"
  display_name = "sds-backup-${var.cluster_name}"
  description  = local.service_accounts["sds-backup-${var.cluster_name}"].description
}

resource "google_project_iam_member" "sds-backup" {
  for_each = toset(local.service_accounts["sds-backup-${var.cluster_name}"].roles)

  member  = "serviceAccount:${google_service_account.sds-backup.email}"
  role    = each.value
  project = local.service_accounts["sds-backup-${var.cluster_name}"].project_id
}
### end pair

### Resource pair, GSA and IAM roles for gtw-con
resource "google_service_account" "gtw-con" {
  project = var.gsa_project_id

  account_id   = "gtw-con-${var.cluster_name}"
  display_name = "gtw-con-${var.cluster_name}"
  description  = local.service_accounts["gtw-con-${var.cluster_name}"].description
}

resource "google_project_iam_member" "gtw-con" {
  for_each = toset(local.service_accounts["gtw-con-${var.cluster_name}"].roles)

  member  = "serviceAccount:${google_service_account.gtw-con.email}"
  role    = each.value
  project = local.service_accounts["gtw-con-${var.cluster_name}"].project_id
}
### end pair

### Resource pair, GSA and IAM roles for src-repo
resource "google_service_account" "src-repo" {
  project = var.gsa_project_id

  account_id   = "src-repo-${var.cluster_name}"
  display_name = "src-repo-${var.cluster_name}"
  description  = local.service_accounts["src-repo-${var.cluster_name}"].description
}

resource "google_project_iam_member" "src-repo" {
  for_each = toset(local.service_accounts["src-repo-${var.cluster_name}"].roles)

  member  = "serviceAccount:${google_service_account.src-repo.email}"
  role    = each.value
  project = local.service_accounts["src-repo-${var.cluster_name}"].project_id
}
### end pair

### Resource pair, GSA and IAM roles for cdi-import
resource "google_service_account" "cdi-import" {
  project = var.gsa_project_id

  account_id   = "cdi-import-${var.cluster_name}"
  display_name = "cdi-import-${var.cluster_name}"
  description  = local.service_accounts["cdi-import-${var.cluster_name}"].description
}

resource "google_project_iam_member" "cdi-import" {
  for_each = toset(local.service_accounts["cdi-import-${var.cluster_name}"].roles)

  member  = "serviceAccount:${google_service_account.cdi-import.email}"
  role    = each.value
  project = local.service_accounts["cdi-import-${var.cluster_name}"].project_id
}
### end pair

### Resource pair, GSA and IAM roles for storage
resource "google_service_account" "storage" {
  project = var.gsa_project_id

  account_id   = "storage-${var.cluster_name}"
  display_name = "storage-${var.cluster_name}"
  description  = local.service_accounts["storage-${var.cluster_name}"].description
}

resource "google_project_iam_member" "storage" {
  for_each = toset(local.service_accounts["storage-${var.cluster_name}"].roles)

  member  = "serviceAccount:${google_service_account.storage.email}"
  role    = each.value
  project = local.service_accounts["storage-${var.cluster_name}"].project_id
}
### end pair