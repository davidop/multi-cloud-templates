# Ejemplos de integración multicloud

Aquí se documentan patrones y ejemplos de integración entre proveedores cloud, como peering de redes, sincronización de secretos, etc.

## Ejemplo: Peering entre Azure y AWS

```mermaid
graph LR
  az-vnet[VNet Azure] -- Peering --> aws-vpc[VPC AWS]
```

## Ejemplo: Sincronización de secretos entre clouds

```mermaid
flowchart LR
  az-kv[Azure Key Vault] -- Sync --> aws-sm[AWS Secrets Manager]
  aws-sm -- Sync --> gcp-sm[GCP Secret Manager]
  gcp-sm -- Sync --> az-kv
```

## Ejemplo: Arquitectura de red híbrida

```mermaid
flowchart TD
  onprem[On-Premises] -- VPN --> az-vnet[Azure VNet]
  onprem -- VPN --> aws-vpc[AWS VPC]
  onprem -- VPN --> gcp-net[GCP Network]
  az-vnet -- Peering --> aws-vpc
  aws-vpc -- Peering --> gcp-net
  gcp-net -- Peering --> az-vnet
```
