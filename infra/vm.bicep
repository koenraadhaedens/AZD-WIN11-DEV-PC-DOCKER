
param location string
param vmName string
param adminPassword string

var storageAccountName = 'bootdiags${uniqueString(resourceGroup().id)}'
var nicName = 'myVMNic'
var addressPrefix = '10.0.0.0/16'
var subnetName = 'Subnet'
var subnetPrefix = '10.0.0.0/24'
var virtualNetworkName = 'MyVNET'
var networkSecurityGroupName = 'default-NSG'

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'Storage'
}

resource publicIP 'Microsoft.Network/publicIPAddresses@2021-02-01' = {
  name: 'DevpcPubip'
  location: location
  sku: {
    name: 'Basic'
  }
  properties: {
    publicIPAllocationMethod: 'Dynamic'
    dnsSettings: {
      domainNameLabel: toLower('${vmName}-${uniqueString(resourceGroup().id, vmName)}')
    }
  }
}

resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2021-02-01' = {
  name: networkSecurityGroupName
  location: location
  properties: {
    securityRules: [
      {
        name: 'default-allow-3389'
        properties: {
          priority: 1000
          access: 'Allow'
          direction: 'Inbound'
          destinationPortRange: '3389'
          protocol: 'Tcp'
          sourcePortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]
    }
  }
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2021-02-01' = {
  name: '${virtualNetworkName}/${subnetName}'
  dependsOn: [
    networkSecurityGroup
    virtualNetwork
  ]
  properties: {
    addressPrefix: subnetPrefix
    networkSecurityGroup: {
      id: networkSecurityGroup.id
    }
  }
}

resource networkInterface 'Microsoft.Network/networkInterfaces@2021-02-01' = {
  name: nicName
  location: location
  dependsOn: [
    publicIP
    subnet
  ]
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIP.id
          }
          subnet: {
            id: subnet.id
          }
        }
      }
    ]
  }
}

resource virtualMachine 'Microsoft.Compute/virtualMachines@2021-03-01' = {
  name: vmName
  location: location
  dependsOn: [
    networkInterface
    storageAccount
  ]
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_D4s_v3'
    }
    osProfile: {
      computerName: vmName
      adminUsername: 'hacker'
      adminPassword: adminPassword
      windowsConfiguration: {
        provisionVMAgent: true
        enableAutomaticUpdates: true
        patchSettings:{
          patchMode:'AutomaticByOS'
          assessmentMode:'ImageDefault'
          enableHotpatching:false
        }
      }
      secrets:[]
      allowExtensionOperations:true
    }
    storageProfile:{
      imageReference:{
        publisher:'MicrosoftWindowsDesktop'
        offer:'windows-11'
        sku:'win11-22h2-pro'
        version:'latest'
      }
      osDisk:{
        createOption:'FromImage'
        managedDisk:{
          storageAccountType:'StandardSSD_LRS'
        }
      }
      dataDisks:[
        {
          diskSizeGB :1023,
          lun :0,
          createOption :'Empty'
        }
      ]
    }
    networkProfile:{
      networkInterfaces:[
        {
          id :networkInterface.id 
        }
      ]
    }
    diagnosticsProfile:{
      bootDiagnostics:{
        enabled:true,
        storageUri :storageAccount.properties.primaryEndpoints.blob 
      }
    } 
  } 
}

resource customScriptExtension 'Microsoft.Compute/virtualMachines/extensions@2021-03-01' ={
name :'${vmName}/CustomScriptExtension',
location :location,
dependsOn:[
virtualMachine 
],
properties:{
autoUpgradeMinorVersion:true,
publisher :'Microsoft.Compute',
type :'CustomScriptExtension',
typeHandlerVersion :'1.9',
settings:{
fileUris:[
'https://sakhdavd.blob.core.windows.net/devpc/devpc.ps1' 
],
commandToExecute :'powershell -ExecutionPolicy Unrestricted -file "./devpc.ps1"' 
},
protectedSettings:{} 
} 
}

output hostname string = publicIP.properties.dnsSettings.fqdn

