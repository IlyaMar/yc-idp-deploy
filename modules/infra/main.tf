data "yandex_resourcemanager_folder" "idp_service_folder" {
  folder_id = var.idp_service_folder_id
}

# k8s agent SA: k8s.clusters.agent и vpc.publicAdmin
# k8s node SA: container-registry.images.puller on docker registry
# k8s ingress-controller SA:
  # alb.editor — для создания необходимых ресурсов.
  # vpc.publicAdmin — для управления внешней связностью.
  # certificate-manager.certificates.downloader — для работы с сертификатами, зарегистрированными в сервисе Certificate Manager.
  # compute.viewer — для использования узлов кластера Managed Service for Kubernetes в целевых группах балансировщика нагрузки.
