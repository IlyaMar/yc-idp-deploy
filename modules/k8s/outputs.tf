output "cluster_id" {
  value = yandex_kubernetes_cluster.cluster.id
}

output "k8s_nodes_security_group_id" {
  value = yandex_vpc_security_group.k8s_sg_nodes.id
}

output "k8s_nodes_logging_group_id" {
  value = yandex_logging_group.k8s_nodes.id
}

output "encryption_kms_key_id" {
  value = yandex_kms_symmetric_key.encryption_kms_key.id
}

output "kubernetes_provider" {
  value = {
    cluster_name                       = yandex_kubernetes_cluster.cluster.name
    cluster_endpoint                   = var.k8s_bastion.enabled ? "https://${yandex_kubernetes_cluster.cluster.id}.${var.k8s_bastion.fqdn_suffix}" : yandex_kubernetes_cluster.cluster.master[0].external_v6_endpoint
    cluster_certificate_authority_data = base64encode(yandex_kubernetes_cluster.cluster.master[0].cluster_ca_certificate)
    api_version                        = "client.authentication.k8s.io/v1beta1"
    kubernetes_provider_command        = "yc"
    kubernetes_provider_args           = ["k8s", "create-token", "--profile", var.yc_profile]
  }
}
