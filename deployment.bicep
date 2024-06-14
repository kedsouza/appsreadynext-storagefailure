param environmentName string 
param containerAppName string 
param azureStorageAccountName string
@secure()
param azureFilesAccountKey string
param azureFilesShareName string
@secure()
param location string = resourceGroup().location

resource environment 'Microsoft.App/managedEnvironments@2022-03-01' existing = {
  name: environmentName
 
 

  resource azurefilestorage 'storages@2022-03-01' = {
    name: 'azurefilestorage'
    properties: {
      azureFile: {
        accountKey: azureFilesAccountKey
        accountName: azureStorageAccountName
        shareName: azureFilesShareName
        accessMode: 'ReadWrite'
      }
    }
  }
}


resource containerApp 'Microsoft.App/containerApps@2023-11-02-preview' = {
  dependsOn: [
    environment
  ]

  name: containerAppName
  location: location
  properties: {
    environmentId: environment.id
    workloadProfileName: 'consumption'

    configuration: {
      ingress: {
        targetPort: 80
        external: true
      }
    }
    template: {
      containers: [
        {
          image: 'nginx:latest'
          name: 'ngnix'
          resources: {
            cpu: json('0.5')
            memory: '1Gi'
          }
          volumeMounts: [
            {
              mountPath: '/test/mountPath'
              // This volumeName should reference the 'volumes' name below
              volumeName: 'azurefilesmount'
            }
          ]
        }
      ]
      scale: {
        minReplicas: 1
        maxReplicas: 1
      }
      volumes: [
        {
          name: 'azurefilesmount'
          storageType: 'AzureFile'
          // This 'storageName' should reference the storage resource created in the managed environment resource (above)
          storageName: 'azurefilestorage'
        }
      ]
    }
  }
}

