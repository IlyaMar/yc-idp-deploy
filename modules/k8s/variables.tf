variable "yc_profile" {
  type = string
}

variable "folder_id" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "cluster_version" {
  type = string
}

variable "k8s_api_v6_address" {
  type = string
  default = null
}

variable "use_public_ipv4" {
  type    = bool
  default = false
}

variable "network_config" {
  type = object({
    region     = string
    network_id = string
    subnets    = map(object({
      zone      = string
      subnet_id = string
    }))
    alb_security_group_ids = list(string)
  })
}

variable "node_groups_config" {
  type = map(object({
    node_labels            = map(string)
    instance_name_template = string
    platform_id            = string
    cores                  = number
    core_fraction          = number
    memory                 = number
    nodes_count            = number
    use_ipv4               = bool
    use_ipv6               = bool
  }))
}

variable "k8s_cluster_agent_sa_id" {
  type = string
}

variable "k8s_node_agent_sa_id" {
  type = string
}

variable "cluster_ipv4_range" {
  type    = string
  default = "10.112.0.0/16"
}
variable "service_ipv4_range" {
  type    = string
  default = "10.96.0.0/16"
}
variable "cluster_ipv6_range" {
  type    = string
  default = "fc00::/96"
}
variable "service_ipv6_range" {
  type    = string
  default = "fc01::/112"
}

variable "office_v6_nets" {
  type = list(string)
}

variable "office_v4_nets" {
  type = list(string)
}

# variable "ydb_security_group_id" {
#   type = string
# }

variable "bastion_locations" {
  description = "subnets of bastion, https://wiki.yandex-team.ru/cloud/security/services/bastion2/k8s-bastion/?from=%2Fcloud%2Fsecurity%2Fservices%2Fk8s-bastion#otbastiondomk8s"
  type        = list(string)
}

variable "k8s_bastion" {
  type = object({
    enabled     = bool
    fqdn_suffix = string
  })
}
