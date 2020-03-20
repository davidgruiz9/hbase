# hbase

az login
az account set --subscription="2c1c3374-9ff5-4aff-9586-b5366e44a8b0"
az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/2c1c3374-9ff5-4aff-9586-b5366e44a8b0"


terraform init
terraform validate
terraform apply -auto-approve
terraform destroy -auto-approve