variable "org_id" {
  description = "The id of the organization"
  type        = string
}

variable "billing_account_id" {
  type = string
}

// folder to which a new fleet deployment should attach
variable "region_folder_name" {
  type = string
}

// A name for the new fleet that is to be deployed
variable "fleet_name" {
  type = string
}

variable "fleet_network_project" {
  type = string
}

variable "fleet_default_region" {
  default = "us-central1"
  type    = string
}

variable "network_name" {
  default = "fleetnet"
  type    = string
}

variable "fleet_router_default_asn" {
  default = "64519"
  type    = string
}

variable "fleet_subnet" {
  description = "subnet to create"
  type = object({
    subnet_name   = string
    subnet_ip     = string
    subnet_region = string
  })
  default = {
    subnet_name   = "fleet-us-central1",
    subnet_ip     = "172.16.100.0/24",
    subnet_region = "us-central1"
  }
}

variable "fleet_secondary_ranges" {
  type = list
}

variable "labels" {
  type = map
}

variable "metadata" {
  type = map
}