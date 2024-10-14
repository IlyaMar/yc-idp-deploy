# Init

```
tfenv use 1.5.7
YCP_PROFILE=prod terraform init -backend-config="secret_key=$(ya vault get version sec-01ewn2b4vf3vmj18c65w1b8wh6 -o AccessSecretKey)"
```

# Run
```
yc config profile activate sandbox
export YC_TOKEN=$(yc iam create-token)
export YC_CLOUD_ID=$(yc config get cloud-id)
export YC_FOLDER_ID=$(yc config get folder-id)
terraform apply

```

# Secret create
```
TF_VAR_secret1_value=super_secret1 terraform apply
Outputs:
lockbox_secret_id = "e6qh381tf4hn4t91ktl7"

```

# ESO
```
cd infra/dev
KUBECONFIG=.kubeconfig_idp_dev helm install \
  --namespace eso \
  --create-namespace \
  --set-file auth.json=.secret/sa-eso-key.json \
  external-secrets ./helm/external-secrets/

Name of your ClusterSecretStore is "cluster-secret-store"

Name of your Secret with sa key credentials for Yandex Cloud sa-creds

In order to begin using ExternalSecrets, you will need to set up a ExternalSecret Object
and refference to your ClusterSecretStore resource - example:

apiVersion: external-secrets.io/v1alpha1
kind: ExternalSecret
metadata:
  name: external-secret
  namespace: ns2 <your namespace>
spec:
  refreshInterval: 1h
  secretStoreRef:
    name: cluster-secret-store <name of yout cluster secret store>
    kind: ClusterSecretStore
  target:
    name: k8s-secret-ns1 <name of target k8s secret object>
  data:
  - secretKey: password
    remoteRef:
      key: e6q9tju0vsjcehdkkbmi <your secret id>
      property: password

```

