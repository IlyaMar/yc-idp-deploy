resource "yandex_kubernetes_node_group" "node_group" {
#   lifecycle {
#     prevent_destroy = true
#   }

  for_each = var.node_groups_config

  cluster_id = yandex_kubernetes_cluster.cluster.id
  name       = each.key
  node_labels = each.value.node_labels

  instance_template {
    name        = each.value.instance_name_template
    platform_id = each.value.platform_id
    container_runtime {
      type = "containerd"
    }

    network_interface {
      ipv4               = each.value.use_ipv4
      ipv6               = each.value.use_ipv6
      nat                = false
      subnet_ids         = [for subnet in data.yandex_vpc_subnet.subnets : subnet.subnet_id]
      security_group_ids = [
        yandex_vpc_security_group.k8s_sg_main.id,
        yandex_vpc_security_group.k8s_sg_nodes.id,
        yandex_vpc_security_group.k8s_sg_public_services.id,
      ]
    }

    resources {
      cores         = each.value.cores
      core_fraction = each.value.core_fraction
      memory        = each.value.memory
    }

    scheduling_policy {
      preemptible = false
    }
  }

  allocation_policy {
    dynamic location {
      for_each = data.yandex_vpc_subnet.subnets
      content {
        zone = location.value.zone
      }
    }
  }

  scale_policy {
    fixed_scale {
      size = each.value.nodes_count
    }
  }
}
