variable "cluster_name" {
  type = string
}

variable "project_id" {
  type        = string
  description = "project in which to create service accounts and IAM bindings"
}