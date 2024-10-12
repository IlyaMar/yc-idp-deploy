module "idp_k8s" {
  source = "../k8s"

  yc_profile              = var.env
  folder_id               = data.yandex_resourcemanager_folder.idp_service_folder.id
  cluster_name            = "${var.k8s_config.cluster_name}-${var.env}"
  cluster_version         = var.k8s_config.cluster_version
  k8s_cluster_agent_sa_id = var.k8s_cluster_agent_sa_id
  k8s_node_agent_sa_id    = var.k8s_node_agent_sa_id
#   k8s_api_v6_address      = data.ycp_vpc_address.k8s_master_address_ipv6.ipv6_address[0].address
  network_config          = var.network_config
  node_groups_config      = var.k8s_config.node_groups
  office_v6_nets          = var.office_v6_nets
  office_v4_nets          = var.office_v4_nets
#   ydb_security_group_id   = yandex_vpc_default_security_group.default_security_group.id
  bastion_locations       = var.bastion_locations
  k8s_bastion             = var.k8s_bastion
}

