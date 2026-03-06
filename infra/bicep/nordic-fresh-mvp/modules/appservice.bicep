// appservice.bicep - Azure App Service (Linux, B1)
param location string
param tags object
param uniqueSuffix string

resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
	name: 'nff-asp-${uniqueSuffix}'
	location: location
	sku: {
		name: 'B1'
		tier: 'Basic'
	}
	kind: 'linux'
	tags: tags
}

resource webApp 'Microsoft.Web/sites@2022-03-01' = {
	name: 'nff-app-${uniqueSuffix}'
	location: location
	kind: 'app,linux'
	tags: tags
	properties: {
		serverFarmId: appServicePlan.id
		httpsOnly: true
		clientAffinityEnabled: false
		siteConfig: {
			linuxFxVersion: 'DOTNETCORE|6.0'
		}
	}
}
