// monitor.bicep - Azure Monitor (Log Analytics)
param location string
param tags object
param uniqueSuffix string

resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2021-12-01-preview' = {
	name: 'nff-mon-${uniqueSuffix}'
	location: location
	tags: tags
	sku: {
		name: 'PerGB2018'
	}
	properties: {
		retentionInDays: 30
	}
}
