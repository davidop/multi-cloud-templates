#!/bin/bash
# Test básico para despliegue de recursos en GCP (VM y red)
# Ejecutar dentro del devcontainer

set -e

# Proyecto y red (ajusta los valores según tu entorno)
PROJECT_ID=$(gcloud config get-value project)
NETWORK_NAME="network-demo"
VM_NAME="vm-demo"
ZONE="us-central1-a"

# Verifica que la red existe
gcloud compute networks describe $NETWORK_NAME --project $PROJECT_ID > /dev/null 2>&1
if [[ $? -ne 0 ]]; then
  echo "ERROR: No se encontró la red $NETWORK_NAME en el proyecto $PROJECT_ID."
  exit 1
fi

echo "Red encontrada: $NETWORK_NAME"

# Verifica que existe al menos una VM en la red
gcloud compute instances list --filter="name=($VM_NAME)" --project $PROJECT_ID --format="value(name)" | grep $VM_NAME > /dev/null 2>&1
if [[ $? -ne 0 ]]; then
  echo "ERROR: No se encontró la VM $VM_NAME en la red $NETWORK_NAME."
  exit 1
fi

echo "VM encontrada: $VM_NAME"
echo "Test de despliegue GCP completado."
