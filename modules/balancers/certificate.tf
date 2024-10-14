resource "yandex_cm_certificate" "api_gw_certs" {
  lifecycle {
    prevent_destroy = true
  }

  for_each = {for d in var.custom_domains : d.alias => d}

  folder_id   = var.folder_id
  name        = "${each.key}-apigw-cert"
  description = "Used by ${each.value.fqdn}"
  domains     = [
    each.value.fqdn,
  ]
  managed {
    challenge_type = "DNS_CNAME"
  }
}

resource "yandex_dns_recordset" "api_gw_certs_validation" {
  lifecycle {
    prevent_destroy = true
  }

  for_each = {for d in var.custom_domains : d.alias => d if d.zone_id != null}

  zone_id = each.value.zone_id
  name    = yandex_cm_certificate.api_gw_certs[each.key].challenges[0].dns_name
  type    = yandex_cm_certificate.api_gw_certs[each.key].challenges[0].dns_type
  data    = [yandex_cm_certificate.api_gw_certs[each.key].challenges[0].dns_value]
  ttl     = 200
}

data "yandex_cm_certificate" "api_gw_certs_validated" {
  for_each = {for d in var.custom_domains : d.alias => d if d.zone_id != null}

  depends_on = [
    yandex_dns_recordset.api_gw_certs_validation,
  ]
  certificate_id  = yandex_cm_certificate.api_gw_certs[each.key].id
  wait_validation = true
}
