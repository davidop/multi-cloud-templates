#!/bin/bash
# Test básico para despliegue de recursos en AWS (EC2 y VPC)
# Ejecutar dentro del devcontainer

set -e

# Verifica que Terraform haya creado la VPC
VPC_ID=$(aws ec2 describe-vpcs --filters Name=tag:Name,Values=vpc-demo --query 'Vpcs[0].VpcId' --output text)
if [[ "$VPC_ID" == "None" ]]; then
  echo "ERROR: No se encontró la VPC con el tag Name=vpc-demo."
  exit 1
fi

echo "VPC encontrada: $VPC_ID"

# Verifica que existe al menos una instancia EC2 en la VPC
EC2_COUNT=$(aws ec2 describe-instances --filters Name=vpc-id,Values=$VPC_ID --query 'Reservations[*].Instances[*].InstanceId' --output text | wc -w)
if [[ $EC2_COUNT -lt 1 ]]; then
  echo "ERROR: No se encontraron instancias EC2 en la VPC."
  exit 1
fi

echo "Instancias EC2 encontradas en la VPC: $EC2_COUNT"
echo "Test de despliegue AWS completado."
