module "constants0" {
  source = "../../modules/constants"
}

locals {
  # only for k8s cluster name
  env            = "prod"
  ycp_profile = "sandbox-prod"
  endpoints = {
    api                       = "api.cloud.yandex.net:443"
    access_service            = "direct://as.private-api.cloud.yandex.net:4286"
    resource_manager_service  = "rm.private-api.cloud.yandex.net:4284"
    symmetric_crypto_service  = "kms.yandex:8443"
    iam_private_api           = "iam.private-api.cloud.yandex.net:4283"
    token_service             = "ts.private-api.cloud.yandex.net:4282"
  }

  # ilya-martynov-dev
  idp_service_folder_id = "b1gu8md6fhhv44pq8ml7"

  # ilya-martynov-net
  network_config = {
    region     = "ru-central1"
    network_id = "enpt251nnf3j3gdlrk15"
    subnets    = {
      a = {
        zone      = "ru-central1-a"
        subnet_id = "e9b2p50gaq3cson3a2qv"
      }
      b = {
        zone      = "ru-central1-b"
        subnet_id = "e2l137pk1godlo7hengq"
      }
      d = {
        zone      = "ru-central1-d"
        subnet_id = "fl830efe6ias3ld5ivn3"
      }
    }
    # alb-idp
    alb_security_group_ids = [
      "enp2pngeb6sdhnbl1tjo",
    ]
  }
  k8s_config = {
    # cluster1
    cluster_id            = "cat7l0mjq4mj513u8pcd"
    k8s_api_v6_address_id = "xxx"

    nodes_specs = {
      idp_server = {
        nodes_count = {
          release = 1
          canary  = 1
        }
        node_labels = {
          "yc.app" = "idp-server"
        }
        instance_name_prefix = "idp-server"
        platform_id          = "standard-v3"
        cores                = 2
        core_fraction        = 20
        memory               = 4
        use_ipv4             = true
        use_ipv6             = false
      }
    }
  }
  # nlb_ip   id: e9bp4ji0kntm103pavm7   name: private-api-leak-detector-nlb-ipv6
  nlb_ip                     = "xxx"
  alb_for_gateway_fqdn       = "alb-for-gw.idp.cloud.yandex.net:443"
  service_dns_zone_id        = "xxx"

  # folder crpsh8lqvs5nupoi3v85 bench-iam
  docker_registry = "cr.yandex/crpsh8lqvs5nupoi3v85"

  idp_server_values = {
    idpServer = {
      endpoints = {
        idpServer = {
          useTLS = true
        }
      }
      encryption = {
        type   = "yc-kms"
        config = {
          # key1
          kms_key_id = "abjavl3u5cgfptkco9hr"
        }
        yc-kms = {
          symmetric_crypto_service_endpoint = local.endpoints.symmetric_crypto_service
          auth                              = {
            type = "YANDEX_CLOUD_OVERLAY_METADATA"
          }
        }
      }
      certificates = [
#         {
#           k8s_secret_name = "cert-leak-detector"
#           certificate_id  = "fpq2p2a75bs8jum5hidt"
#         },
      ]
      lockbox_secrets = [
#         {
#           k8s_secret_name                   = "yandex-passport-blackbox-service-tvm-secret"
#           secret_keys_to_lockbox_secret_ids = {
#             "v1" = "e6qs82f3a2aed2cbkj46"
#           }
#         },
      ]
    }
    unifiedAgent = {
      enabled = true
    }
  }

}

module "infra" {
  source = "../../modules/infra"

  env                                       = local.env
  ycp_profile                               = local.ycp_profile
  yc_api_endpoint                           = local.endpoints.api
  idp_service_folder_id           = local.idp_service_folder_id
  use_internal_ca_at_external_secret_stores = false

  k8s_cluster_agent_sa_id = "ajef38cjdpj4d7sho4nh"
  k8s_node_agent_sa_id = "aje2e4fc9gr7s4huc59k"

  network_config = local.network_config

  k8s_config = {
    cluster_version = "1.28"
    cluster_name    = "idp"

    node_groups = merge([
      for _, nodes_spec in local.k8s_config.nodes_specs : {
        for group_name, nodes_count in nodes_spec.nodes_count :
        "${nodes_spec.instance_name_prefix}-${group_name}" => {
          node_labels = merge(
            nodes_spec.node_labels,
            {
              "yc.restriction" = group_name
            },
          )
          instance_name_template = "${nodes_spec.instance_name_prefix}-${group_name}-{instance.zone_id}-{instance.index_in_zone}"
          platform_id            = nodes_spec.platform_id
          cores                  = nodes_spec.cores
          core_fraction          = nodes_spec.core_fraction
          memory                 = nodes_spec.memory
          use_ipv4               = nodes_spec.use_ipv4
          use_ipv6               = nodes_spec.use_ipv6
          nodes_count            = nodes_count
        }
      }
    ]...)
  }

  k8s_api_v6_address_id = local.k8s_config.k8s_api_v6_address_id

  namespaces = {
#     "idp-dataplane" = {
#       lockbox_secrets = local.lockbox_secrets
#       certificates    = local.leak_detector_certificates
#     }
  }

  bastion_locations = [
    "2a02:6b8:c0e:500:0:f847:696:0/112",
    "2a02:6b8:c02:900:0:f847:696:0/112",
    "2a02:6b8:c41:1300:0:f847:696:0/112",
  ]
  k8s_bastion = {
    enabled     = true
    fqdn_suffix = "k8s.bastion.cloud.yandex.net"
  }
}
