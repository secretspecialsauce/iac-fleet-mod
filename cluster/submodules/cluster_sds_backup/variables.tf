variable "cluster_name" {
  type = string
}

variable "project_id" {
  type        = string
  description = "project in which to create SDS bucket"
}

variable "bucket_location" {
  type        = string
  description = "location in which to create storage bucket (eg. region (i.e. us-central1) or multi-region (i.e. US)"
}

variable "bucket_service_account" {
  type        = string
  description = "service accounts to which access is granted in the form of 'serviceAccount:$gsaEmail'"
}

variable "prefix" {
  type        = string
  description = "bucket prefix"
}

variable "service_account_project" {
  type        = string
  description = "project id of service account project"
}

variable "secret_project" {
  type        = string
  description = "project id of secret project"
}