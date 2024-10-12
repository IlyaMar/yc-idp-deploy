data "yandex_vpc_network" "net" {
  network_id = var.network_config.network_id
}

data "yandex_vpc_subnet" "subnets" {
  for_each = var.network_config.subnets

  subnet_id = each.value.subnet_id
}
