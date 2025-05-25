@description('Nombre del clúster AKS')
param aksName string = 'aks-demo'

@description('Ubicación del clúster')
param location string = resourceGroup().location

@description('SKU del nodo')
param agentVMSize string = 'Standard_DS2_v2'

@description('Cantidad de nodos')
param agentCount int = 1

@description('Habilitar clúster privado (API server privado)')
param enablePrivateCluster bool = true

@description('ID de la subred para los nodos AKS')
param subnetId string = ''

@description('ID del Log Analytics Workspace para logs opcional')
param logAnalyticsWorkspaceId string = ''

@description('Habilitar integración con Azure AD (Microsoft Entra ID) RBAC')
param enableAzureRBAC bool = true

@description('Versión de Kubernetes (vacío para default)')
param kubernetesVersion string = ''

resource aks 'Microsoft.ContainerService/managedClusters@2023-01-01' = {
  name: aksName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    dnsPrefix: aksName
    kubernetesVersion: kubernetesVersion
    agentPoolProfiles: [
      {
        name: 'nodepool1'
        count: agentCount
        vmSize: agentVMSize
        osType: 'Linux'
        mode: 'System'
        vnetSubnetID: subnetId != '' ? subnetId : null
      }
    ]
    networkProfile: {
      networkPlugin: 'azure'
      networkPolicy: 'azure'
      loadBalancerSku: 'standard'
      outboundType: 'loadBalancer'
    }
    apiServerAccessProfile: {
      enablePrivateCluster: enablePrivateCluster
    }
    aadProfile: enableAzureRBAC ? {
      managed: true
      enableAzureRBAC: true
      adminGroupObjectIDs: [] // Personalizar si se requiere
    } : null
    addonProfiles: logAnalyticsWorkspaceId != '' ? {
      omsagent: {
        enabled: true
        config: {
          logAnalyticsWorkspaceResourceID: logAnalyticsWorkspaceId
        }
      }
    } : {}
  }
}

output aksName string = aks.name
output aksFqdn string = aks.properties.fqdn
output aksResourceId string = aks.id
