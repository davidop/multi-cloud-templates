@description('Nombre de la VNet')
param name string

@description('Ubicación de la VNet')
param location string = resourceGroup().location

@description('Dirección CIDR principal')
param addressPrefix string = '10.0.0.0/16'

@description('Prefijos de subredes')
param subnetPrefixes array = [ '10.0.1.0/24' ]

@description('Nombres de subredes')
param subnetNames array = [ 'subnet-aks' ]

resource vnet 'Microsoft.Network/virtualNetworks@2023-04-01' = {
  name: name
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [ addressPrefix ]
    }
    subnets: [
      for (subnetName, i) in subnetNames: {
        name: subnetName
        properties: {
          addressPrefix: subnetPrefixes[i]
        }
      }
    ]
  }
}

output vnetName string = vnet.name
output vnetId string = vnet.id
output subnetResourceIds array = [for (subnetName, i) in subnetNames: resourceId('Microsoft.Network/virtualNetworks/subnets', name, subnetName)]
