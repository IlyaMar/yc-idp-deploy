variable "env" {
  type = string
}

variable "folder_id" {
  type = string
}

variable "k8s_cluster_id" {
  type = string
}

variable "k8s_bastion" {
  type = object({
    enabled     = bool
    fqdn_suffix = string
  })
}

variable "values" {
  type = list(string)

  default = []
}

variable "set_values" {
  type = list(object({
    name  = string
    value = string
  }))

  default = []
}

variable "network_id" {
  type = string
}

variable "alb_for_gateway_fqdn" {
  type = string
}

variable "custom_domains" {
  type = list(object({
    alias   = string
    fqdn    = string
    zone_id = string
  }))
}

variable "github_secret_scanner_custom_domains" {
  type = list(object({
    domain = string
    certificate_id = string
  }))
}
