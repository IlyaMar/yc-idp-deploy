resource "yandex_vpc_security_group" "k8s_sg_main" {
  name        = "${var.cluster_name}-main"
  folder_id   = var.folder_id
  description = "IDP. Group rules ensure the basic performance of the cluster. Apply it to the cluster and node groups."
  network_id  = var.network_config.network_id

  ingress {
    protocol          = "TCP"
    description       = "Rule allows availability checks from load balancer's address range. It is required for the operation of a fault-tolerant cluster and load balancer services."
    predefined_target = "loadbalancer_healthchecks"
    from_port         = 0
    to_port           = 65535
  }
  ingress {
    protocol          = "ANY"
    description       = "Rule allows master-node and node-node communication inside a security group."
    predefined_target = "self_security_group"
    from_port         = 0
    to_port           = 65535
  }

  ingress {
    protocol       = "ANY"
    description    = "Rule allows pod-pod and service-service communication. Specify the subnets of your cluster and services."
    v4_cidr_blocks = [var.cluster_ipv4_range, var.service_ipv4_range]
    v6_cidr_blocks = [var.cluster_ipv6_range, var.service_ipv6_range]
    from_port      = 0
    to_port        = 65535
  }

  ingress {
    protocol       = "ICMP"
    description    = "Rule allows debugging ICMP packets from internal subnets."
    v4_cidr_blocks = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
  }

  egress {
    protocol       = "ANY"
    description    = "Rule allows all outgoing traffic. Nodes can connect to Yandex Container Registry, Yandex Object Storage, Docker Hub, and so on."
    v4_cidr_blocks = ["0.0.0.0/0"]
    v6_cidr_blocks = ["::/0"]
    from_port      = 0
    to_port        = 65535
  }

    ingress {
      protocol       = "TCP"
      description    = "https://wiki.yandex-team.ru/cloud/security/services/bastion2/k8s-bastion/?from=%2Fcloud%2Fsecurity%2Fservices%2Fk8s-bastion#otbastiondomk8s"
      port           = 443
      v6_cidr_blocks = var.bastion_locations
    }
}

resource "yandex_vpc_security_group" "k8s_sg_public_services" {
  name        = "${var.cluster_name}-public"
  folder_id   = var.folder_id
  description = "Only for nodes. As in https://cloud.yandex.ru/docs/managed-kubernetes/operations/security-groups#examples"
  network_id  = var.network_config.network_id

  dynamic "ingress" {
    for_each = toset(var.network_config.alb_security_group_ids)
    iterator = security_group_id

    content {
      protocol          = "ANY"
      description       = "Rule allows incoming traffic from the internet (ALB Security Group id: ${security_group_id.value}) to the NodePort port range. Add ports or change existing ones to the required ports."
      security_group_id = security_group_id.value
      from_port         = 30000
      to_port           = 32767
    }
  }
}

resource "yandex_vpc_security_group" "k8s_sg_nodes" {
  name        = "${var.cluster_name}-nodes"
  folder_id   = var.folder_id
  description = "Only for nodes. As in https://cloud.yandex.ru/docs/managed-kubernetes/operations/security-groups#examples"
  network_id  = var.network_config.network_id

#   TODO replace on IAM YDB endpoint
#   egress {
#     protocol          = "ANY"
#     description       = "Rule allows outgoing traffic to YDB security group."
#     security_group_id = var.ydb_security_group_id
#     port              = 2135
#   }

  ingress {
    protocol       = "ANY"
    description    = "Rule allows incoming traffic from the devops (office) nets to the NodePort port range (For access to k8s services/load-balancers)."
    v6_cidr_blocks = var.office_v6_nets
    v4_cidr_blocks = var.office_v4_nets
    from_port      = 30000
    to_port        = 32767
  }
}

resource "yandex_vpc_security_group" "k8s_sg_master" {
  name        = "${var.cluster_name}-master"
  folder_id   = var.folder_id
  description = "Only for cluster. Access Kubernetes API from the devops (office) nets. As in https://cloud.yandex.ru/docs/managed-kubernetes/operations/security-groups#examples."
  network_id  = var.network_config.network_id

  ingress {
    protocol       = "TCP"
    description    = "Access Kubernetes API on 443"
    v6_cidr_blocks = var.office_v6_nets
    v4_cidr_blocks = var.office_v4_nets
    # also 6443 ?
    port           = 443
  }
}
