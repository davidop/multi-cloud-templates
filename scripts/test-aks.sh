# Ejemplo de test básico para despliegue de AKS con Bicep
# Este script asume que tienes configurado Azure CLI y acceso al grupo de recursos

RESOURCE_GROUP=${1:-mi-grupo-dev}
AKS_NAME=${2:-aks-demo}

# Verifica que el clúster AKS existe y está en estado Succeeded
az aks show --resource-group "$RESOURCE_GROUP" --name "$AKS_NAME" --query "provisioningState" -o tsv

# Verifica que el nodo pool tiene al menos un nodo
az aks nodepool list --resource-group "$RESOURCE_GROUP" --cluster-name "$AKS_NAME" --query "[0].count" -o tsv

echo "Test de despliegue AKS completado."
