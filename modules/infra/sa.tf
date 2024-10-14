resource "ycp_iam_service_account" "ic_sa" {
  folder_id = var.idp_service_folder_id
  name = "ingress-controller"
}

resource "ycp_resource_manager_folder_iam_member" "ic_sa_folder_roles" {
  folder_id = var.idp_service_folder_id
  for_each = toset([
    "alb.editor",
    "vpc.publicAdmin",
    "certificate-manager.certificates.downloader",
    "compute.viewer",
  ])
  role = each.value
  member = "serviceAccount:${ycp_iam_service_account.ic_sa.id}"
}


# aje80ki70beg6jnqb5ii
resource "ycp_iam_service_account" "eso_sa" {
  folder_id = var.idp_service_folder_id
  name = "eso-controller"
}

resource "ycp_resource_manager_folder_iam_member" "eso_sa_folder_roles" {
  folder_id = var.idp_service_folder_id
  for_each = toset([
    "lockbox.viewer",
  ])
  role = each.value
  member = "serviceAccount:${ycp_iam_service_account.eso_sa.id}"
}


# IC_SA_ID=aje80ki70beg6jnqb5ii
# yc --profile=sandbox iam key create \
#  --service-account-id $IC_SA_ID \
#  --output sa-eso-key.json
