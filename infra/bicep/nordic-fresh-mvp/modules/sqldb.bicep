// sqldb.bicep - Azure SQL Database (Serverless, 5 DTU)
param location string
param tags object
param uniqueSuffix string

resource sqlServer 'Microsoft.Sql/servers@2022-05-01-preview' = {
	name: 'nff-sqlsrv-${uniqueSuffix}'
	location: location
	tags: tags
	properties: {
		administratorLogin: 'sqladminuser'
		administratorLoginPassword: 'ChangeMe123!'
		version: '12.0'
	}
}

resource sqlDb 'Microsoft.Sql/servers/databases@2022-05-01-preview' = {
	name: '${sqlServer.name}/nff-sqldb-${uniqueSuffix}'
	location: location
	tags: tags
	sku: {
		name: 'GP_S_Gen5_1'
		tier: 'GeneralPurpose'
		family: 'Gen5'
		capacity: 1
	}
	properties: {
		zoneRedundant: false
		collation: 'SQL_Latin1_General_CP1_CI_AS'
	}
}
