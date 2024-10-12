resource "yandex_logging_group" "k8s_master" {
  lifecycle {
    prevent_destroy = true
  }

  name             = "${var.cluster_name}-k8s-master"
  folder_id        = var.folder_id
  retention_period = "72h"
}

resource "yandex_logging_group" "k8s_nodes" {
  lifecycle {
    prevent_destroy = true
  }

  name             = "${var.cluster_name}-k8s-nodes"
  folder_id        = var.folder_id
  retention_period = "72h"
}
