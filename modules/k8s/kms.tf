resource "yandex_kms_symmetric_key" "k8s_kms_key" {
  lifecycle {
    prevent_destroy = true
  }

  name              = "${var.cluster_name}-key"
  folder_id         = var.folder_id
  default_algorithm = "AES_128"
  rotation_period   = "720h" # 1 month.
}

# do we need it?
resource "yandex_kms_symmetric_key" "encryption_kms_key" {
  lifecycle {
    prevent_destroy = true
  }

  name              = "idp-encryption-key"
  description       = "KMS key for enctryption key"
  folder_id         = var.folder_id
  default_algorithm = "AES_256"
}
