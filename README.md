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
- [Metodología Recomendada](#metodología-recomendada)
- [Mejoras Propuestas](#mejoras-propuestas)
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

> **Metodología recomendada:**  
> - **Azure:** Bicep (nativo, simple, integración directa con Azure)  
> - **AWS y GCP:** Terraform (modular, estándar multicloud, fácil de versionar y reutilizar)  
> - **Módulos reutilizables** por proveedor  
> - **Variables y configuración** por entorno (`dev`, `test`, `prod`)  
> - **Pipelines** para CI/CD y validación

```text
infra/
├── azure/         # Bicep para Azure
│   ├── main.bicep
│   └── modules/
├── aws/           # Terraform para AWS
│   ├── main.tf
│   └── modules/
├── gcp/           # Terraform para GCP
│   ├── main.tf
│   └── modules/
├── modules/       # (Opcional) Módulos reutilizables por proveedor
├── environments/  # dev / test / prod variables y parámetros
│   ├── dev/
│   ├── test/
│   └── prod/
├── scripts/       # Scripts de validación y testing automatizado
│   ├── validate-all.sh
│   ├── test-aks.sh
│   ├── test-aws.sh
│   └── test-gcp.sh
├── pipelines/     # GitHub Actions / Azure DevOps
│   └── azure-pipelines.yml
├── docs/          # Documentación extendida y ejemplos
├── CONTRIBUTING.md
├── LICENSE
└── README.md
```

- **/scripts:** Scripts para validación y testing automatizado.
- **/docs:** Documentación extendida, ejemplos y guías de uso.
- **/modules:** (Opcional) Módulos reutilizables por proveedor.
- **/environments:** Variables y parámetros por entorno.
- **/pipelines:** Definiciones de CI/CD.
- **README.md:** Documentación principal.
- **LICENSE:** Licencia del repositorio.

---

## Diagramas de Arquitectura

### Relación Multi-Cloud

```mermaid
graph TD
  Azure --> AWS
  AWS --> GCP
  GCP --> Azure
```

### Diagrama de Arquitectura General Multi-Cloud

```mermaid
flowchart TD
    subgraph Azure
        az-vnet[VNet]
        az-subnet[Subnet]
        az-nsg[NSG]
        az-aks[AKS Cluster]
        az-vm[VM]
        az-sa[Storage Account]
        az-kv[Key Vault]
        az-vnet --> az-subnet
        az-subnet --> az-nsg
        az-subnet --> az-aks
        az-subnet --> az-vm
        az-aks --> az-kv
        az-vm --> az-sa
        az-vm --> az-kv
    end
    subgraph AWS
        aws-vpc[VPC]
        aws-subnet[Subnet]
        aws-ec2[EC2]
        aws-s3[S3 Bucket]
        aws-secrets[Secrets Manager]
        aws-vpc --> aws-subnet
        aws-subnet --> aws-ec2
        aws-ec2 --> aws-s3
        aws-ec2 --> aws-secrets
    end
    subgraph GCP
        gcp-net[Network]
        gcp-subnet[Subnet]
        gcp-vm[VM]
        gcp-bucket[Storage Bucket]
        gcp-secrets[Secret Manager]
        gcp-net --> gcp-subnet
        gcp-subnet --> gcp-vm
        gcp-vm --> gcp-bucket
        gcp-vm --> gcp-secrets
    end
    az-vnet --- aws-vpc
    aws-vpc --- gcp-net
    gcp-net --- az-vnet
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

### Azure (Bicep)

```bash
az deployment group create --resource-group <grupo> --template-file azure/main.bicep --parameters @environments/dev/azure-parameters.json
```

### AWS (Terraform)

```bash
cd aws
terraform init
terraform apply -var-file=../environments/dev/terraform.tfvars
```

### GCP (Terraform)

```bash
cd gcp
terraform init
terraform apply -var-file=../environments/dev/terraform.tfvars
```

---

## Ejemplo Multi-Cloud

Puedes desplegar recursos en los tres proveedores ejecutando los scripts de cada carpeta o integrando los pasos en un pipeline CI/CD.

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

Puedes consultar y modificar la pipeline en el archivo `pipelines/azure-pipelines.yml`.

---

## Metodología Recomendada

- **Azure:** Mantén Bicep como estándar para equipos que trabajan solo con Azure.
- **AWS y GCP:** Usa Terraform como lenguaje común para equipos multicloud.
- **Módulos reutilizables:** Organiza módulos por proveedor y reutiliza lógica donde sea posible.
- **Variables y configuración por entorno:** Centraliza parámetros y variables en `/environments`.
- **Automatización:** Usa pipelines para validación, despliegue y testing automático.
- **Gestión de secretos:** Utiliza Key Vault (Azure), Secrets Manager (AWS) y Secret Manager (GCP) según el entorno.

Esta metodología permite a cada equipo trabajar con la herramienta más eficiente para su entorno, sin sacrificar la coherencia ni la trazabilidad de las implementaciones.

---

## Mejoras Propuestas

1. **Unificar la estructura bajo `/infra/`**  
   Mueve todas las carpetas de proveedores y entornos bajo una raíz común (`/infra/`) para mayor claridad y escalabilidad.

2. **Agregar carpeta `/scripts/`**  
   Centraliza scripts de validación, testing y automatización para facilitar su mantenimiento y descubrimiento.

3. **Crear carpeta `/docs/`**  
   Incluye documentación extendida, diagramas, ejemplos de uso y guías de buenas prácticas.

4. **Ejemplos de módulos reutilizables**  
   Añade ejemplos de módulos reutilizables para cada proveedor en `/infra/modules/` y referencia su uso en la documentación.

5. **Automatización avanzada en CI/CD**  
   - Añade jobs de lint y seguridad para Terraform (`tflint`, `tfsec`, `checkov`).
   - Añade jobs de testing post-deploy usando los scripts de `/scripts/`.
   - Publica artefactos de validación y reportes de seguridad en cada pipeline.

6. **Documentación de patrones de integración multicloud**  
   En `/docs/`, incluye ejemplos de patrones de integración entre clouds (por ejemplo, peering entre Azure y AWS, sincronización de secretos, etc).

7. **Plantillas de issues y PRs**  
   Añade archivos `.github/ISSUE_TEMPLATE/` y `.github/pull_request_template.md` para estandarizar la colaboración.

8. **Ejemplo de gestión de secretos**  
   Documenta y ejemplifica cómo gestionar secretos de forma segura en cada cloud y cómo integrarlo en pipelines.

9. **Guía de migración y adopción**  
   Incluye una guía para equipos que migran de un solo cloud a multicloud, con recomendaciones de adopción progresiva.

10. **Badges de estado adicionales**  
    Añade badges para validación de AWS, GCP y cobertura de tests.

---

## Estructura recomendada de carpetas y archivos

```text
infra/
├── azure/
│   ├── main.bicep
│   └── modules/
│       └── storage.bicep         # Ejemplo de módulo reutilizable Azure
├── aws/
│   ├── main.tf
│   └── modules/
│       └── s3_bucket.tf          # Ejemplo de módulo reutilizable AWS
├── gcp/
│   ├── main.tf
│   └── modules/
│       └── storage_bucket.tf     # Ejemplo de módulo reutilizable GCP
├── modules/
│   ├── README.md                 # Documentación de módulos reutilizables
├── environments/
│   ├── dev/
│   │   ├── azure-parameters.json
│   │   └── terraform.tfvars
│   ├── test/
│   │   ├── azure-parameters.json
│   │   └── terraform.tfvars
│   └── prod/
│       ├── azure-parameters.json
│       └── terraform.tfvars
├── scripts/
│   ├── validate-all.sh           # Validación multi-cloud
│   ├── test-aks.sh               # Test AKS Azure
│   ├── test-aws.sh               # Test AWS
│   └── test-gcp.sh               # Test GCP
├── pipelines/
│   └── azure-pipelines.yml
├── docs/
│   ├── patrones-integracion.md   # Ejemplos de integración multicloud
│   ├── gestion-secrets.md        # Guía de gestión de secretos
│   └── migracion-multicloud.md   # Guía de migración y adopción
├── .github/
│   ├── ISSUE_TEMPLATE/
│   │   └── bug_report.md
│   │   └── feature_request.md
│   └── pull_request_template.md
├── CONTRIBUTING.md
├── LICENSE
└── README.md
```

### Ejemplo de módulo reutilizable (Azure Bicep)

```bicep
// filepath: /workspaces/multi-cloud-templates/infra/azure/modules/storage.bicep
param name string
param location string
resource storage 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: name
  location: location
  sku: { name: 'Standard_LRS' }
  kind: 'StorageV2'
}
output storageAccountId string = storage.id
```

### Ejemplo de módulo reutilizable (AWS Terraform)

```hcl
// filepath: /workspaces/multi-cloud-templates/infra/aws/modules/s3_bucket.tf
variable "bucket_name" {}
resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name
  acl    = "private"
}
output "bucket_id" {
  value = aws_s3_bucket.this.id
}
```

### Ejemplo de módulo reutilizable (GCP Terraform)

```hcl
// filepath: /workspaces/multi-cloud-templates/infra/gcp/modules/storage_bucket.tf
variable "bucket_name" {}
resource "google_storage_bucket" "this" {
  name     = var.bucket_name
  location = "EU"
}
output "bucket_id" {
  value = google_storage_bucket.this.id
}
```

### Ejemplo de script de validación multi-cloud

```bash
# filepath: /workspaces/multi-cloud-templates/infra/scripts/validate-all.sh
#!/bin/bash
set -e
echo "Validando Bicep Azure..."
az bicep build --file ../azure/main.bicep
az bicep linter --file ../azure/main.bicep

echo "Validando Terraform AWS..."
cd ../aws
terraform init -backend=false
terraform validate
if command -v tfsec; then tfsec .; fi
if command -v checkov; then checkov -d .; fi
cd -

echo "Validando Terraform GCP..."
cd ../gcp
terraform init -backend=false
terraform validate
if command -v tfsec; then tfsec .; fi
if command -v checkov; then checkov -d .; fi
cd -
```

### Ejemplo de plantilla de issue

```markdown
<!-- filepath: /workspaces/multi-cloud-templates/.github/ISSUE_TEMPLATE/bug_report.md -->
---
name: Bug report
about: Reporta un bug para este proyecto
labels: bug
---

**Describe el bug**
Una descripción clara y concisa del problema.

**Pasos para reproducir**
1. Ir a '...'
2. Ejecutar '...'
3. Ver error

**Comportamiento esperado**
Una descripción clara y concisa de lo que esperabas que ocurriera.

**Información adicional**
Agrega cualquier otro contexto sobre el problema aquí.
```

### Ejemplo de plantilla de Pull Request

```markdown
<!-- filepath: /workspaces/multi-cloud-templates/.github/pull_request_template.md -->
## Descripción

<!-- Explica brevemente los cambios realizados -->

## Checklist

- [ ] El código pasa los tests y validaciones
- [ ] La documentación ha sido actualizada si aplica
- [ ] Los scripts y pipelines han sido probados
```

---

Adoptando esta estructura y ejemplos, tu repositorio será más escalable, colaborativo y fácil de mantener para equipos multicloud.
