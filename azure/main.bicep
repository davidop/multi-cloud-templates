module vnet 'modules/vnet.bicep' = {
  name: 'vnetDeployment'
  params: {
    name: 'vnet-demo'
    location: resourceGroup().location
    addressPrefix: '10.0.0.0/16'
    subnetPrefixes: [ '10.0.1.0/24' ]
    subnetNames: [ 'subnet-aks' ]
  }
}

module keyvault 'modules/keyvault.bicep' = {
  name: 'keyvaultDeployment'
  params: {
    name: 'kv-demo'
    location: resourceGroup().location
    adminObjectIds: [] // Agrega aquí los objectId de los administradores si aplica
  }
}

module aks 'modules/aks.bicep' = {
  name: 'aksDeployment'
  params: {
    aksName: 'aks-demo'
    location: resourceGroup().location
    agentVMSize: 'Standard_DS2_v2'
    agentCount: 1
    enableAzureRBAC: true
    enablePrivateCluster: true
    subnetId: vnet.outputs.subnetResourceIds[0]
    logAnalyticsWorkspaceId: '' // Pasa el resourceId del workspace si aplica
    kubernetesVersion: ''
  }
}

module vm 'modules/vm.bicep' = {
  name: 'vmDeployment'
  params: {
    vmName: 'vm-demo'
    location: resourceGroup().location
    vmSize: 'Standard_B2s'
    subnetId: vnet.outputs.subnetResourceIds[0]
    adminUsername: 'azureuser'
    adminPublicKey: 'REEMPLAZAR_CON_CLAVE_PUBLICA_SSH'
  }
}
