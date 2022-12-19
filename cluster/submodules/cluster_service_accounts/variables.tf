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
