@description('Nombre del Key Vault')
param name string

@description('Ubicación del Key Vault')
param location string = resourceGroup().location

@description('SKU del Key Vault')
param skuName string = 'standard'

@description('Permitir acceso público')
param publicNetworkAccess string = 'Disabled' // Solo acceso privado recomendado

@description('Lista de IDs de objetos de administradores')
param adminObjectIds array = []

resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: name
  location: location
  properties: {
    tenantId: subscription().tenantId
    sku: {
      family: 'A'
      name: skuName
    }
    accessPolicies: [
      for objectId in adminObjectIds: {
        tenantId: subscription().tenantId
        objectId: objectId
        permissions: {
          secrets: [ 'get', 'list', 'set', 'delete', 'recover', 'backup', 'restore' ]
          keys: [ 'get', 'list', 'create', 'delete', 'recover', 'backup', 'restore' ]
        }
      }
    ]
    publicNetworkAccess: publicNetworkAccess
    enablePurgeProtection: true
    enableSoftDelete: true
  }
}

output keyVaultName string = keyVault.name
output keyVaultId string = keyVault.id
