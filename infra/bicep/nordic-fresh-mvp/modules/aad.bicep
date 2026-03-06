// aad.bicep - Azure AD (Entra ID)
param location string
param tags object
param uniqueSuffix string

resource userAssignedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
	name: 'nff-identity-${uniqueSuffix}'
	location: location
	tags: tags
}
