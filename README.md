# Init

```
tfenv use 1.5.7
YCP_PROFILE=prod terraform init -backend-config="secret_key=$(ya vault get version sec-01ewn2b4vf3vmj18c65w1b8wh6 -o AccessSecretKey)"
```

# Prepare
```
yc config profile activate sandbox
export YC_TOKEN=$(yc iam create-token)
export YC_CLOUD_ID=$(yc config get cloud-id)
export YC_FOLDER_ID=$(yc config get folder-id)
export KUBECONFIG=.kubeconfig_idp_dev

# run
terraform apply
```

# System resources
## Infra
Security Group, SA, k8s cluster. apply TF.

## Create SA for ingress controller
SA with authorized key
```
SA_ID=xxx
yc --profile=sandbox iam key create \
 --service-account-id $SA_ID \
 --output sa-ic-key.json
```

## Create SA for ESO
SA with authorized key
```
SA_ID=aje80ki70beg6jnqb5ii
yc --profile=sandbox iam key create \
 --service-account-id $SA_ID \
 --output sa-eso-key.json
```

## Install ESO
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


# Application Resources
## Lockbox Secret create
```
TF_VAR_secret1_value=super_secret1 terraform apply
Outputs:
lockbox_secret_id = "e6qh381tf4hn4t91ktl7"
```

## K8s resources
```
# ns
kubectl create namespace app1

```

## Prepare resources for ESO
SA authorized key is per-application, because application has own secrets and own SA accessing them.
```
kubectl --namespace app1 create secret generic yc-auth \
  --from-file=authorized-key=.secret/sa-eso-key.json

kubectl -n app1 apply -f - <<REQ
apiVersion: external-secrets.io/v1beta1
kind: SecretStore
metadata:
  name: secret-store
spec:
  provider:
    yandexlockbox:
      auth:
        authorizedKeySecretRef:
          name: yc-auth
          key: authorized-key
REQ

```

## Create secret managed by ESO
```
kubectl -n app1 apply -f - <<REQ 
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: external-secret
spec:
  refreshInterval: 1h
  secretStoreRef:
    name: secret-store
    kind: SecretStore
  target:
    name: k8s-secret
  data:
  - secretKey: key1
    remoteRef:
      key: e6qh381tf4hn4t91ktl7
      property: key1
REQ

```
