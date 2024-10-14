resource "yandex_api_gateway" "api-gateway" {
  folder_id   = var.folder_id
  name        = "leak-detector-api-gw"
  description = "Leak Detector API GateWay"
  connectivity {
    network_id = var.network_id
  }
  dynamic custom_domains {
    for_each = {for d in var.custom_domains : d.alias => d}
    content {
      fqdn           = custom_domains.value.fqdn
      certificate_id = custom_domains.value.zone_id != null ? data.yandex_cm_certificate.api_gw_certs_validated[custom_domains.value.alias].id : yandex_cm_certificate.api_gw_certs[custom_domains.value.alias].id
    }
  }
  dynamic custom_domains {
    for_each = {for d in var.github_secret_scanner_custom_domains : d.domain => d}
    content {
      fqdn           = custom_domains.value.domain
      certificate_id = custom_domains.value.certificate_id
    }
  }
  timeouts {
    create = "20m"
    update = "20m"
  }
  spec = <<-EOT
openapi: "3.0.0"
info:
  version: 1.0.0
  title: secret-scanner-gw
paths:
  /:
    post:
      x-yc-apigateway-integration:
        type: http
        url: https://${var.alb_for_gateway_fqdn}/github/verify
        headers:
          GITHUB-PUBLIC-KEY-IDENTIFIER: '{GITHUB-PUBLIC-KEY-IDENTIFIER}'
          GITHUB-PUBLIC-KEY-SIGNATURE: '{GITHUB-PUBLIC-KEY-SIGNATURE}'
          Content-Type: '{Content-Type}'
          X-Request-Id: '{X-Request-Id}'
        query:
          '*': '*'
      parameters:
      - name: GITHUB-PUBLIC-KEY-IDENTIFIER
        in: header
        required: true
        schema:
          type: string
      - name: GITHUB-PUBLIC-KEY-SIGNATURE
        in: header
        required: true
        schema:
          type: string
      - name: Content-Type
        in: header
        required: true
        schema:
          type: string
      - name: X-Request-Id
        in: header
        required: true
        schema:
          type: string
      operationId: secret-scanner

EOT
}
