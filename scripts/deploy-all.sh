# Ejemplo de script de despliegue multi-cloud

# Este script asume que tienes configuradas las credenciales para Azure, AWS y GCP en el devcontainer.

# Despliegue en Azure
az deployment group create --resource-group $AZURE_RG --template-file azure/main.bicep --parameters @environments/dev/azure-parameters.json

# Despliegue en AWS
cd aws
terraform init
terraform apply -var-file=../environments/dev/terraform.tfvars -auto-approve
cd ..

# Despliegue en GCP
cd gcp
terraform init
terraform apply -var-file=../environments/dev/terraform.tfvars -auto-approve
cd ..
