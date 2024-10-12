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
