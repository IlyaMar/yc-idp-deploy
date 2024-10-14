resource "yandex_lockbox_secret" "secret" {
  folder_id = local.idp_service_folder_id
  name = "idp1"
}

# resource "yandex_lockbox_secret_version" "my_version" {
#   secret_id = yandex_lockbox_secret.secret.id
#   entries {
#     key        = "key1"
#     text_value = var.secret1_value
#   }
# }

output "lockbox_secret_id" {
  value = yandex_lockbox_secret.secret.id
}