output "leak_detector_api_gateway_name" {
  value = yandex_api_gateway.api-gateway.name
}

output "leak_detector_api_gateway_fqdn" {
  value = yandex_api_gateway.api-gateway.domain
}
