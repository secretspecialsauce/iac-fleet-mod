variable "cluster_name" {
  type = string
}

variable "gsa_project_id" {
  type        = string
  description = "project in which to create service accounts"
}

variable "secret_project_id" {
  type        = string
  description = "project in which to create secrets"
}

variable "gsa_gcr_agent_iam_project" {
  type        = string
  description = "project in which to create IAM bindings for the named service account"
}

variable "gsa_abm_gke_connect_agent_iam_project" {
  type        = string
  description = "project in which to create IAM bindings for the named service account"
}

variable "gsa_abm_gke_register_agent_iam_project" {
  type        = string
  description = "project in which to create IAM bindings for the named service account"
}

variable "gsa_acm_monitoring_agent_iam_project" {
  type        = string
  description = "project in which to create IAM bindings for the named service account"
}

variable "gsa_abm_ops_agent_iam_project" {
  type        = string
  description = "project in which to create IAM bindings for the named service account"
}

variable "gsa_external_secrets_iam_project" {
  type        = string
  description = "project in which to create IAM bindings for the named service account"
}

variable "gsa_sds_backup_agent_iam_project" {
  type        = string
  description = "project in which to create IAM bindings for the named service account"
}

variable "gsa_gateway_connect_agent_iam_project" {
  type        = string
  description = "project in which to create IAM bindings for the named service account"
}

variable "gsa_cdi_import_agent_iam_project" {
  type        = string
  description = "project in which to create IAM bindings for the named service account"
}

variable "gsa_storage_agent_iam_project" {
  type        = string
  description = "project in which to create IAM bindings for the named service account"
}

# TODO add target machine when ready
#variable "gsa_target_machine_iam_project" {
#  type        = string
#  description = "project in which to create IAM bindings for the named service account"
#}

variable "sds_bucket_prefix" {
  type        = string
  description = "bucket prefix"
}

variable "sds_bucket_location" {
  type        = string
  description = "location in which to create SDS bucket (eg. region (i.e. us-central1) or multi-region (i.e. US)"
}

variable "sds_project_id" {
  type        = string
  description = "project in which to create SDS bucket"
}

variable "sds_bucket_service_accounts" {
  type        = list(string)
  description = "service accounts to which access is granted in the form of 'serviceAccount:$gsaEmail'"
  default     = []
}