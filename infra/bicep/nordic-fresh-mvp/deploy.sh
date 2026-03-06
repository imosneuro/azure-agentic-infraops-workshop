#!/bin/bash
# Deploy nordic-fresh-mvp Bicep infrastructure to Azure
# Usage: ./deploy.sh <resource-group> [location]

set -e

RG_NAME="$1"
LOCATION="${2:-swedencentral}"
BICEP_FILE="$(dirname "$0")/main.bicep"
PARAM_FILE="$(dirname "$0")/main.bicepparam"

if [ -z "$RG_NAME" ]; then
  echo "Usage: $0 <resource-group> [location]"
  exit 1
fi

# Create resource group if it doesn't exist
az group show --name "$RG_NAME" >/dev/null 2>&1 || \
  az group create --name "$RG_NAME" --location "$LOCATION"

echo "Deploying nordic-fresh-mvp to resource group: $RG_NAME in $LOCATION..."
az deployment group create \
  --resource-group "$RG_NAME" \
  --template-file "$BICEP_FILE" \
  --parameters "@$PARAM_FILE"

echo "Deployment complete."
