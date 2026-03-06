// main.bicep - Orchestrates all modules for nordic-fresh-mvp
// AVM-first, CAF naming, security baseline

param environment string = 'dev'
param project string = 'nordic-fresh-mvp'
param location string = 'swedencentral'
param owner string
param tags object = {
  Environment: environment
  ManagedBy: 'Bicep'
  Project: project
  Owner: owner
}

var uniqueSuffix = uniqueString(resourceGroup().id)

module appservice 'modules/appservice.bicep' = {
  name: 'appservice-${uniqueSuffix}'
  params: {
    location: location
    tags: tags
    uniqueSuffix: uniqueSuffix
  }
}

module sqldb 'modules/sqldb.bicep' = {
  name: 'sqldb-${uniqueSuffix}'
  params: {
    location: location
    tags: tags
    uniqueSuffix: uniqueSuffix
  }
}

module keyvault 'modules/keyvault.bicep' = {
  name: 'keyvault-${uniqueSuffix}'
  params: {
    location: location
    tags: tags
    uniqueSuffix: uniqueSuffix
  }
}

module storage 'modules/storage.bicep' = {
  name: 'storage-${uniqueSuffix}'
  params: {
    location: location
    tags: tags
    uniqueSuffix: uniqueSuffix
  }
}

module frontdoor 'modules/frontdoor.bicep' = {
  name: 'frontdoor-${uniqueSuffix}'
  params: {
    location: location
    tags: tags
    uniqueSuffix: uniqueSuffix
  }
}

module appinsights 'modules/appinsights.bicep' = {
  name: 'appinsights-${uniqueSuffix}'
  params: {
    location: location
    tags: tags
    uniqueSuffix: uniqueSuffix
  }
}

module monitor 'modules/monitor.bicep' = {
  name: 'monitor-${uniqueSuffix}'
  params: {
    location: location
    tags: tags
    uniqueSuffix: uniqueSuffix
  }
}

module aad 'modules/aad.bicep' = {
  name: 'aad-${uniqueSuffix}'
  params: {
    location: location
    tags: tags
    uniqueSuffix: uniqueSuffix
  }
}
