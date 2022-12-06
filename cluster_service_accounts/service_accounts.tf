resource "google_service_account" "default" {
  for_each = local.service_accounts

  project = var.gsa_project_id

  account_id = each.key
  name       = each.value.description
}

resource "google_project_iam_member" "default" {
  for_each = toset(flatten([
    for k, v in local.service_accounts : [
      for role in v.roles : "${k}=>${role}"
    ]
  ]))

  project = var.gsa_iam_project_id
  role    = split("=>", each.value)[1]
  member  = "serviceAccount:${google_service_account.default[split("=>", each.value)[0]].email}"

  depends_on = [google_service_account.default]
}
