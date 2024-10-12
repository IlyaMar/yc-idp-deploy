data "yandex_iam_service_account" "k8s_cluster_agent_sa" {
  service_account_id = var.k8s_cluster_agent_sa_id
}

data "yandex_iam_service_account" "k8s_node_agent_sa" {
  service_account_id = var.k8s_node_agent_sa_id
}
