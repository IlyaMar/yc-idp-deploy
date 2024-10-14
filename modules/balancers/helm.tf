locals {
  app       = "load-balancers"
  namespace = "leak-detector"
}

module "constants_k8s_provider" {
  source = "../../general/constants_k8s_provider/yc"

  yc_profile      = var.env
  k8s_cluster_id  = var.k8s_cluster_id
  use_public_ipv4 = false
  k8s_bastion     = var.k8s_bastion
}

module "load_balancers" {
  source = "../../general/helm/v1"

  name      = "${local.app}-${var.env}"
  namespace = local.namespace
  chart     = "${path.module}/../../../../helm/${local.app}"

  kubernetes_provider = module.constants_k8s_provider.kubernetes_provider

  set_values = var.set_values

  values = concat(
    [
      templatefile("${path.module}/values.yaml", {
        namespace : local.namespace
      })
    ],
    var.values,
  )
}
