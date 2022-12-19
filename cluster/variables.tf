variable "cluster_name" {
  type = string
}

variable "fleet_project_id" {
  type = string
}

variable "gsa_project_id" {
  type        = string
  description = "project id of named purpose"
}

variable "secrets_project_id" {
  type        = string
  description = "project id of named purpose"
}

variable "observability_project_id" {
  type        = string
  description = "project id of named purpose"
}

variable "network_project_id" {
  type        = string
  description = "project id of named purpose"
}

variable "sds_project_id" {
  type        = string
  description = "project in which to create SDS bucket"
}

variable "sds_bucket_prefix" {
  type        = string
  description = "bucket prefix"
}

variable "sds_bucket_location" {
  type        = string
  description = "location in which to create SDS bucket (eg. region (i.e. us-central1) or multi-region (i.e. US)"
}

variable "snapshot_bucket_location" {
  type        = string
  description = "location in which to create SDS bucket (eg. region (i.e. us-central1) or multi-region (i.e. US)"
}