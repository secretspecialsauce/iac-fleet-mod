variable "org_id" {
  description = "The id of the organization"
  type        = string
}

variable "fleet_name" {
  type = string
}

variable "fleet_parent_folder" {
  type        = string
  description = "folder to which a new fleet deployment should attach"
}

variable "billing_account_id" {
  type = string
}

variable "project_prefix" {
  type    = string
  default = ""
}
