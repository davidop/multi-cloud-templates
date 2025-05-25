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
