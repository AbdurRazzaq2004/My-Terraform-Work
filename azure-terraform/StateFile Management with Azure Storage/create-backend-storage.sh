#!/bin/bash

# ==============================================================
# Script: create-backend-storage.sh
# Purpose: Creates Azure resources needed to store the Terraform
#          state file in a remote backend (Azure Blob Storage)
# ==============================================================

RESOURCE_GROUP_NAME=tfstate-backend
STORAGE_ACCOUNT_NAME=tfstatebackendstorage
CONTAINER_NAME=tfstate-backend

# Step 1: Create a Resource Group
az group create --name $RESOURCE_GROUP_NAME --location eastus

# Step 2: Create a Storage Account with LRS replication and blob encryption
az storage account create --resource-group $RESOURCE_GROUP_NAME --name $STORAGE_ACCOUNT_NAME --sku Standard_LRS --encryption-services blob

# Step 3: Create a Blob Container inside the Storage Account
az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME

# Print the storage account name (you will need this in main.tf)
echo ""
echo "=============================================="
echo "Backend storage created successfully!"
echo "=============================================="
echo "Resource Group:     $RESOURCE_GROUP_NAME"
echo "Storage Account:    $STORAGE_ACCOUNT_NAME"
echo "Container Name:     $CONTAINER_NAME"
echo "=============================================="
echo ""
echo "Use the Storage Account name above in your main.tf backend configuration."
