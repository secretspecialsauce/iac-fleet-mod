variable "cluster_name" {}
variable "project_id" {}
variable "region" {}
variable "router" {}
variable "tunnels" {}
variable "peer_asn" {
  default = "64515"
}
variable "router_ips" {
  type = object({
    interface1 = object({
      ip_range = string
      peer_ip  = string
    })
    interface2 = object({
      ip_range = string
      peer_ip  = string
    })
  })

  default = {
    interface1 = {
      ip_range = "169.254.0.1/30"
      peer_ip  = "169.254.0.2"
    }
    interface2 = {
      ip_range = "169.254.1.1/30"
      peer_ip  = "169.254.1.2"
    }
  }
}