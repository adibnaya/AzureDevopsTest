---
description: This template demonstrates create 2 servers and join them to a private AD domain on azure, and also creating 2 member servers and join them to the same domain, also running a user creation script.
page_type: sample
products:
- azure
- azure-resource-manager
urlFragment: vm-domain-join
languages:
- json
- bicep
---
# Create domain with 2 DCs, 2 Member servers and domain users in a new OU

[![Deploy To Azure](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazure.svg?sanitize=true)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fadibnaya%2FAzureDevopsTest%2Fmain%2Fmain.json)
[![Deploy To Azure US Gov](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazuregov.svg?sanitize=true)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fadibnaya%2FAzureDevopsTest%2Fmain%2Fmain.json)
[![Visualize](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/visualizebutton.svg?sanitize=true)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fadibnaya%2FAzureDevopsTest%2Fmain%2Fmain.json)

This template creates domain controllers in a new domain, 2 Member servers in the same domain and domain users in a new OU.
There is a parameters file to be used with the main.bicep template file

If the deployment fails with the Conflict error message during deployment of the CustomScriptExtension component, use the following steps to remediate this issue:

In the Azure portal, on the Deployment blade, review the deployment details and identify the VM(s) where the installation of the CustomScriptExtension failed
In the Azure portal, navigate to the blade of the VM(s) you identified in the previous step, select Extensions, and from the Extensions blade, remove the CustomScript extension
Redeploy your bicep template with the same code

If the AD users are not created you need to go to the PDC VM and delete the "installScript" extension and run the deploy again

## REQUIREMENTS

1. Existing resource group

`Tags: Microsoft.Storage/storageAccounts, Microsoft.Network/networkInterfaces, Microsoft.Compute/virtualMachines, Microsoft.Compute/virtualMachines/extensions, JsonADDomainExtension, Microsoft.Resources/deployments`
