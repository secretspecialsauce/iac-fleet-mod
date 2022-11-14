variable "org_id" {
  description = "The id of the organization"
  type        = string
}

// A name for the new fleet that is to be deployed
variable "fleet_folder_name" {
  type = string
}

// folder to which a new fleet deployment should attach
variable "region_folder_name" {
  type = string
}

variable "billing_account_id" {
  type = string
}