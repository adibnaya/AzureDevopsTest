param dcDeplymentName string = 'azurelabdc${uniqueString(resourceGroup().id)}'
param msDeplymentName string = 'azurelabms${uniqueString(resourceGroup().id)}'

@description('The name of the Administrator of the new VM and Domain')
param adminUsername string

@description('Location for the VM, only certain regions support zones during preview.')
@allowed([
  'centralus'
  'eastus'
  'eastus2'
  'francecentral'
  'northeurope'
  'southeastasia'
  'ukwest'
  'westus2'
  'westeurope'
])
param location string

@description('The password for the Administrator account of the new VM and Domain')
@secure()
param adminPassword string

@description('The FQDN of the AD Domain created ')
param domainName string = 'contoso.local'

@description('The DNS prefix for the public IP address used by the Load Balancer')
param dnsPrefix string

@description('The location of resources such as templates and DSC modules that the script is dependent')
param _artifactsLocation string = 'https://raw.githubusercontent.com/adibnaya/AzureDevopsTest/main/create-2-dcs/'

param vmSize string = 'Standard_Ds1_v2'

param subscriptionId string

param subscriptionName string

var domainJoinOptions = 3
var storageAccountName = 'azurelabsa${uniqueString(resourceGroup().id)}'
var dnsLabelPrefix = 'azurelabmsdns${uniqueString(resourceGroup().id)}'
var scriptUrl = 'https://raw.githubusercontent.com/adibnaya/AzureDevopsTest/main/domain-users/create_users.ps1'
var scriptFilename = 'create_users.ps1'

module Deploy2Dcs './create-2-dcs/deploy2dcs.bicep' = {
  name: dcDeplymentName
  params: {
    adminUsername: adminUsername
    location: location
    adminPassword: adminPassword
    domainName: domainName
    dnsPrefix: dnsPrefix
    vmSize: vmSize
    _artifactsLocation: _artifactsLocation
  }
}

resource domainUserCreateScript 'Microsoft.Compute/virtualMachines/extensions@2019-07-01' = {
  name: 'adPDC/installScript'
  location: location
  tags: {
    displayName: 'customScript for Domain user creation'
  }
  properties: {
    publisher: 'Microsoft.Compute'
    type: 'CustomScriptExtension'
    typeHandlerVersion: '1.10'
    autoUpgradeMinorVersion: true
    settings: {
      fileUris: [
        scriptUrl
      ]
    }
    protectedSettings: {
      commandToExecute: 'powershell -ExecutionPolicy Bypass -file  ${scriptFilename}'
    }
  }
  dependsOn: [
    Deploy2Dcs
  ]
}

module DeployMemberServers './vm-domain-join/vm-domain-join.bicep' = {
  name: msDeplymentName
  params: {
    adminUsername: adminUsername
    location: location
    adminPassword: adminPassword
    existingVnetName: Deploy2Dcs.outputs.virtualNetworkName
    existingSubnetName: Deploy2Dcs.outputs.adSubnetName
    vmSize: vmSize
    domainToJoin: domainName
    domainUsername: adminUsername
    domainPassword: adminPassword
    domainJoinOptions: domainJoinOptions
    storageAccountName: storageAccountName
    dnsLabelPrefix: dnsLabelPrefix
  }
}

module DeployDashboard './dashboard/dashboard.bicep' = {
  name: 'dashboardDeploy'
  params: {
    location: location
    subscriptionId: subscriptionId
    subscriptionName: subscriptionName
  }
}
