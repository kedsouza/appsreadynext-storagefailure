#!/bin/bash

az deployment group create \
  --resource-group "kedsouza-ca-no-vnet" \
  --template-file ./deployment.bicep \
  --parameters \
    environmentName="managedEnvironment-kedsouzacanovne-82d8" \
    containerAppName="kedsouza-example1-nginx-3" \
    azureStorageAccountName="kedsouzastorageaccount" \
    azureFilesAccountKey="24sTSshorNGhUkyeXj6voXvZWPBeII/jL5I8UHJGkwtqOWfgXWU4woTh4qudJnrn9x7QDkDt17ku+AStjtbjBw==" \
    azureFilesShareName="fileshare2" \
