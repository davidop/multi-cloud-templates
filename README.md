[![Deploy Azure Bicep](https://github.com/davidop/multi-cloud-templates/actions/workflows/deploy-azure.yml/badge.svg)](https://github.com/davidop/multi-cloud-templates/actions/workflows/deploy-azure.yml)

# Multi-Cloud Templates

[Badges de estado]

## Tabla de Contenidos

- [Introducción](#introducción)
- [Propósito](#propósito)
- [Características](#características)
- [Estructura del Repositorio](#estructura-del-repositorio)
- [Diagramas de Arquitectura](#diagramas-de-arquitectura)
- [Mejores Prácticas](#mejores-prácticas)
- [Guía Rápida por Proveedor](#guía-rápida-por-proveedor)
- [Ejemplo Multi-Cloud](#ejemplo-multi-cloud)
- [Validación y Seguridad](#validación-y-seguridad)
- [Testing Automático](#testing-automático)
- [CI/CD Multi-Cloud](#cicd-multi-cloud-con-azure-pipelines)
- [Contribuir](#contribuir)
- [Licencia](#licencia)

---

## Introducción

Este repositorio contiene plantillas modulares para Azure, AWS y GCP, facilitando la implementación de soluciones multi-cloud siguiendo las mejores prácticas de cada proveedor.

## Propósito

Sirve como ejemplo para programadores de infraestructura como código (IaC) que buscan implementar soluciones multi-cloud siguiendo las mejores prácticas recomendadas por Microsoft (Azure), Amazon (AWS) y Google (GCP).

## Características

- Plantillas modulares y reutilizables para cada proveedor cloud.
- Estructura y nomenclatura estandarizada.
- Ejemplos de implementación y despliegue.
- Documentación sobre mejores prácticas de seguridad, escalabilidad y mantenimiento.

## Estructura del Repositorio

```text
multi-cloud-templates/
├── azure/
│   ├── main.bicep
│   └── modules/
├── aws/
│   ├── main.tf
│   └── modules/
├── gcp/
│   ├── main.tf
│   └── modules/
├── environments/
│   ├── dev/
│   ├── test/
│   └── prod/
├── .azure-pipelines/
│   └── azure-pipelines.yml
├── CONTRIBUTING.md
├── LICENSE
└── README.md
```

- **/azure, /aws, /gcp:** Carpetas específicas para cada proveedor cloud que contienen módulos, plantillas y documentación relacionada.
- **/comun:** Recursos y módulos compartidos entre los diferentes proveedores cloud.
- **README.md:** Documentación principal del repositorio.
- **LICENSE:** Información sobre la licencia del repositorio.

## Diagramas de Arquitectura

### Relación Multi-Cloud

```mermaid
graph TD
  Azure --> AWS
  AWS --> GCP
  GCP --> Azure
```

### Diagrama de Arquitectura en Azure

```mermaid
graph LR
    subgraph Azure
        az-vnet[VNet]
        az-subnet[Subnet]
        az-nsg[NSG]
        az-vm[VM]
        az-sa[Storage Account]
        az-kv[Key Vault]
    end
    az-vnet --> az-subnet
    az-subnet --> az-vm
    az-subnet --> az-nsg
    az-vm --> az-sa
    az-vm --> az-kv
```

---

## Mejores Prácticas

- **Azure:** Se siguen las [Azure Well-Architected Framework](https://learn.microsoft.com/azure/architecture/framework/) y las recomendaciones de seguridad y gobernanza de Microsoft.
- **AWS:** Se aplican las [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/) y las guías de buenas prácticas de Amazon.
- **GCP:** Se implementan las [Google Cloud Architecture Framework](https://cloud.google.com/architecture/framework) y las recomendaciones de Google.

| Proveedor | Framework                                                                                     | Ejemplo de Mejores Prácticas                                                   |
| --------- | --------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------ |
| Azure     | [Azure Well-Architected Framework](https://learn.microsoft.com/azure/architecture/framework/) | Uso de módulos reutilizables, parámetros seguros, control de acceso y tagging. |
| AWS       | [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/)       | Separación de recursos, variables parametrizadas, integración con IAM y VPC.   |
| GCP       | [Google Cloud Architecture Framework](https://cloud.google.com/architecture/framework)        | Modularidad, uso de variables, control de acceso y buenas prácticas de red.    |

---

## Guía Rápida por Proveedor

### Azure

```bash
az deployment group create --resource-group <grupo> --template-file azure/main.bicep --parameters @environments/dev/azure-parameters.json
```

### AWS

```bash
cd aws
terraform init
terraform apply -var-file=../environments/dev/terraform.tfvars
```

### GCP

```bash
cd gcp
terraform init
terraform apply -var-file=../environments/dev/terraform.tfvars
```

---

## Ejemplo Multi-Cloud

Puedes desplegar recursos en los tres proveedores ejecutando los scripts de cada carpeta o integrando los pasos en un pipeline CI/CD (ver `azure-pipelines.yml`).

### Despliegue Coordinado Multi-Cloud

```bash
# Azure
az deployment group create --resource-group <grupo> --template-file azure/main.bicep --parameters @environments/dev/azure-parameters.json

# AWS
cd aws
terraform init
terraform apply -var-file=../environments/dev/terraform.tfvars -auto-approve
cd ..

# GCP
cd gcp
terraform init
terraform apply -var-file=../environments/dev/terraform.tfvars -auto-approve
cd ..
```

> **Consejo:** Personaliza los scripts para cada entorno (`dev`, `test`, `prod`) y utiliza variables de entorno para mayor seguridad.

---

## Validación y Seguridad

- **Azure:** Usa `bicep build` y `bicep linter` para validar las plantillas.
- **AWS/GCP:** Usa `terraform validate` y herramientas como `tfsec` o `checkov` para escaneo de seguridad.

### Validación Automática Multi-Cloud

Puedes validar todas las plantillas de Azure, AWS y GCP automáticamente ejecutando el siguiente script dentro del devcontainer:

```bash
./scripts/validate-all.sh
```

Este script realiza:

- Build y lint de plantillas Bicep (Azure)
- Init, validate y escaneo de seguridad (tfsec, checkov) para Terraform (AWS y GCP)

Asegúrate de tener permisos y credenciales configuradas si alguna validación requiere acceso a la nube.

---

## Testing Automático

- **Azure:** `./scripts/test-aks.sh <nombre-grupo-recursos> <nombre-aks>`
- **AWS:** `./scripts/test-aws.sh`
- **GCP:** `./scripts/test-gcp.sh`

Estos scripts validan la existencia y estado de los recursos principales desplegados en cada proveedor.

---

## CI/CD Multi-Cloud con Azure Pipelines

Este repositorio incluye una pipeline unificada (`azure-pipelines.yml`) que valida, despliega y testea automáticamente la infraestructura en Azure, AWS y GCP. El flujo es el siguiente:

1. **Validación**
   - Azure: build y lint de plantillas Bicep.
   - AWS/GCP: init, validate y escaneo de seguridad (tfsec, checkov) para Terraform.
2. **Despliegue**
   - Azure: despliegue de recursos con Bicep.
   - AWS/GCP: despliegue de recursos con Terraform.
3. **Testing automático**
   - Azure: test de clúster AKS (`scripts/test-aks.sh`).
   - AWS: test de VPC e instancias EC2 (`scripts/test-aws.sh`).
   - GCP: test de red y VM (`scripts/test-gcp.sh`).

Puedes consultar y modificar la pipeline en el archivo `azure-pipelines.yml`.

---

## Contribuir

Las contribuciones son bienvenidas. Por favor, lee el archivo [CONTRIBUTING.md](http://_vscodecontentref_/4) para más detalles sobre cómo contribuir a este repositorio.

## Licencia

Este proyecto está bajo la licencia [MIT](http://_vscodecontentref_/5).
