# e6qh381tf4hn4t91ktl7
resource "yandex_lockbox_secret" "secret" {
  folder_id = local.idp_service_folder_id
  name = "idp1"
}

# apply one time to create a secret
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