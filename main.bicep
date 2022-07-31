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
param _artifactsLocation string = ''

param vmSize string = 'Standard_Ds1_v2'

param domainJoinOptions int

var storageAccountName = 'azurelabsa${uniqueString(resourceGroup().id)}'
var dnsLabelPrefix = 'azurelabmsdns${uniqueString(resourceGroup().id)}'

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