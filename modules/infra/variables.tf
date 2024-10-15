

variable "env" {
  type = string
}

variable "ycp_profile" {
  type = string
}

variable "yc_api_endpoint" {
  type = string
}

variable "use_internal_ca_at_external_secret_stores" {
  type        = bool
  description = "Use Internal Root CA certificate for non PROD envs."
}

variable "namespaces" {
  type = map(object({
    lockbox_secrets = list(object({
      k8s_secret_name                   = string
      secret_keys_to_lockbox_secret_ids = map(string)
    }))
    certificates = list(object({
      k8s_secret_name = string
      certificate_id  = string
    }))
  }))
}

variable "idp_service_folder_id" {
  type    = string
}

variable "k8s_cluster_agent_sa_id" {
  type    = string
  default = "yc.leak-detector.k8sClusterAgent"
}

variable "k8s_node_agent_sa_id" {
  type    = string
  default = "yc.leak-detector.k8sNodeAgent"
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

variable "k8s_config" {
  type = object({
    cluster_version = string
    cluster_name    = string

    node_groups = map(object({
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
  })
}

variable "k8s_api_v6_address_id" {
  type = string
}

variable "office_v6_nets" {
  type    = list(string)

  default = [
    "2620:10f:d000::/44",
    "2a02:6b8::/29",
    "2a0e:fd87::/32",
    "2a0e:fd80::/29",
    "2a02:6bf:8000::/34"
  ]
}

variable "office_v4_nets" {
  type    = list(string)
  default = []
}

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
