// frontdoor.bicep - Azure Front Door (Standard/Premium)
param location string
param tags object
param uniqueSuffix string

resource frontDoorProfile 'Microsoft.Cdn/profiles@2021-06-01' = {
	name: 'nff-fd-${uniqueSuffix}'
	location: location
	sku: {
		name: 'Standard_Microsoft'
	}
	tags: tags
}
// TODO: Add endpoint, WAF, and routing config
