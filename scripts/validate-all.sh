#!/bin/bash
# Script de validación automática para Azure, AWS y GCP
# Ejecutar dentro del devcontainer

set -e

# Validación Azure (Bicep)
echo "Validando plantillas Bicep de Azure..."
bicep build azure/main.bicep
bicep linter azure/main.bicep

# Validación AWS (Terraform)
echo "Validando plantillas Terraform de AWS..."
cd aws
terraform init -backend=false
terraform validate
if command -v tfsec; then tfsec .; fi
if command -v checkov; then checkov -d .; fi
cd ..

# Validación GCP (Terraform)
echo "Validando plantillas Terraform de GCP..."
cd gcp
terraform init -backend=false
terraform validate
if command -v tfsec; then tfsec .; fi
if command -v checkov; then checkov -d .; fi
cd ..

echo "Validación automática completada para Azure, AWS y GCP."
