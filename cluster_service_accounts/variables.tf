variable "cluster_name" {
  type = string
}

variable "gsa_project_id" {
  type        = string
  description = "project in which to create service accounts"
}

variable "gsa_iam_project_id" {
  type        = string
  description = "project in which to create IAM bindings for GSAs"
}