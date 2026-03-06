// storage.bicep - Azure Storage Account (Hot LRS)
param location string
param tags object
param uniqueSuffix string

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
	name: 'nffst${uniqueSuffix}'
	location: location
	sku: {
		name: 'Standard_LRS'
	}
	kind: 'StorageV2'
	tags: tags
	properties: {
		accessTier: 'Hot'
		allowBlobPublicAccess: false
		minimumTlsVersion: 'TLS1_2'
		supportsHttpsTrafficOnly: true
	}
}
