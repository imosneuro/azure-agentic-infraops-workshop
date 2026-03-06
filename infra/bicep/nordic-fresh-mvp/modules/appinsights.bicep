// appinsights.bicep - Application Insights
param location string
param tags object
param uniqueSuffix string

resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
	name: 'nff-ai-${uniqueSuffix}'
	location: location
	tags: tags
	kind: 'web'
	properties: {
		Application_Type: 'web'
	}
}
