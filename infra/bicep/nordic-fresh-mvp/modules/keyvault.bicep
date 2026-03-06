// keyvault.bicep - Azure Key Vault
param location string
param tags object
param uniqueSuffix string

resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' = {
	name: 'nff-kv-${uniqueSuffix}'
	location: location
	tags: tags
	properties: {
		sku: {
			family: 'A'
			name: 'standard'
		}
		tenantId: subscription().tenantId
		accessPolicies: []
		enableSoftDelete: true
		enablePurgeProtection: true
		enabledForDeployment: true
		enabledForTemplateDeployment: true
		enabledForDiskEncryption: true
	}
}
