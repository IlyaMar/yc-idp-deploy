resource "yandex_vpc_default_security_group" "default_security_group" {
  network_id  = var.network_config.network_id
}

# https://paste.yandex-team.ru/f4b7868e-918c-4944-a1f7-151749bfb0a2
# ask duty VPC to enable VPC_IPV6_ALPHA on cloud yc.iam.sandbox-cloud
resource "yandex_vpc_security_group_rule" "ingress_ssh_from_office_nets" {
  security_group_binding = yandex_vpc_default_security_group.default_security_group.id
  direction              = "ingress"
  protocol               = "TCP"
  description            = "Rule allows SSH from Yandex office nets."
  port                   = 22
  v6_cidr_blocks         = var.office_v6_nets
}

