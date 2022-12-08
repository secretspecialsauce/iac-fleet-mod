variable "cluster_name" {}
variable "project_id" {}
variable "region" {}
variable "router" {}
variable "tunnels" {}

variable "router_ifs" {
  description = "router interfaces to create for each tunnel"
  type = object({
    interface1 = object({
      ip_range = string
      peer_ip  = string
      peer_asn = string
    })
    interface2 = object({
      ip_range = string
      peer_ip  = string
      peer_asn = string
    })
  })

  default = {
    interface1 = {
      ip_range = "169.254.0.1/30"
      peer_ip  = "169.254.0.2"
      peer_asn = "64515"
    }
    interface2 = {
      ip_range = "169.254.1.1/30"
      peer_ip  = "169.254.1.2"
      peer_asn = "64515"
    }
  }
}