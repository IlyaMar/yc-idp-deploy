resource "yandex_kubernetes_cluster" "cluster" {
#   lifecycle {
#     prevent_destroy = true
#   }

  name       = var.cluster_name
  folder_id  = var.folder_id
  network_id = var.network_config.network_id

  cluster_ipv4_range = var.cluster_ipv4_range
  service_ipv4_range = var.service_ipv4_range
#   cluster_ipv6_range = var.cluster_ipv6_range
#   service_ipv6_range = var.service_ipv6_range

  service_account_id      = data.yandex_iam_service_account.k8s_cluster_agent_sa.id
  node_service_account_id = data.yandex_iam_service_account.k8s_node_agent_sa.id

  master {
    version = var.cluster_version

    public_ip           = var.use_public_ipv4
    external_v6_address = var.k8s_api_v6_address

    dynamic master_location {
      for_each = data.yandex_vpc_subnet.subnets
      content {
        zone      = master_location.value.zone
        subnet_id = master_location.value.subnet_id
      }
    }

    security_group_ids = [
      yandex_vpc_security_group.k8s_sg_main.id,
      yandex_vpc_security_group.k8s_sg_master.id,
    ]

    master_logging {
      enabled                    = true
      log_group_id               = yandex_logging_group.k8s_master.id
      kube_apiserver_enabled     = true
      cluster_autoscaler_enabled = true
      events_enabled             = true
    }
  }

  kms_provider {
    key_id = yandex_kms_symmetric_key.k8s_kms_key.id
  }
}
