

az login
az account set -s $SUBSCRIPTION_ID

terraform init
terraform plan
terraform apply

# Install CLI extentions
az aks install-cli

# Push image to ACR
az acr login --name wtacr101
docker tag microsoft/azure-vote-front:v1 wtacr101.azurecr.io/azure-vote-front:v1
docker push wtacr101.azurecr.io/azure-vote-front:v1

# Get ACR admin password
az acr credential show --name wtacr101 --resource-group wellnesstrace --query "passwords[0].value"
