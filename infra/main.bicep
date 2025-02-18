
param location string = resourceGroup().location
param vmName string = 'dev-pcxxxx'
param adminPassword string

module vm 'vm.bicep' = {
  name: 'vmDeployment'
  params: {
    location: location
    vmName: vmName
    adminPassword: adminPassword
  }
}
