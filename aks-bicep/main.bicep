@description('The name of the Managed Cluster resource.')
param clusterName string = 'devnexus2023cluster'

@description('The location of the Managed Cluster resource.')
param location string = resourceGroup().location

@description('Optional DNS prefix to use with hosted Kubernetes API server FQDN.')
param dnsPrefix string

@description('Disk size (in GB) to provision for each of the agent pool nodes. This value ranges from 0 to 1023. Specifying 0 will apply the default disk size for that agentVMSize.')
@minValue(0)
@maxValue(1023)
param osDiskSizeGB int = 0

@description('The number of nodes for the cluster.')
@minValue(1)
@maxValue(50)
param agentCount int = 3

@description('The size of the Virtual Machine.')
param agentVMSize string = 'standard_d2s_v3'

@description('User name for the Linux Virtual Machines.')
param linuxAdminUsername string = 'devnexusadmin'

@description('Configure all linux machines with the SSH RSA public key string. Your key should include three parts, for example \'ssh-rsa AAAAB...snip...UcyupgH azureuser@linuxvm\'')
param sshRSAPublicKey string = 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDpgBBbMeQYHRHaTOHyZqcz9K/eXBMbWCHyY4O2Us/axlr2gCDyBktnPBsBev8D3TLDO5wWeVDcHnFN7AX5dMLcmYlXD+4j84/SzphJRkzFlkTSJFNMBS3u02BVxMnR6b1kENNUOnfvfqgUQORVNKLLg4Ikc1bGj7NOfhuc0Q/lzeSt5l+ZOmveEtMhFBGuHy9Qj/d3e36Lb4LAUEmNKaBADsVgl79SDkgAo78SmJjl4g9hMg0+abAS9f36CfmFMSJn21n7uDAspvXrJrUfGfH4U630SXge3p2i1U4dY/c4yL66SnwDp8SxB2qYJTxiJDjEZUI3MShman1o7oXj9WnqT+KhCZgWcdz6s/oc9y5Nw6NoI2plLzQf7HMVdDsmWefKXKPCYdhwfBHGG1XlmeRY1JlcySTg/LxtFPEeTKAnmN/Yt3/EDFb6nQRkrhY7Yim9abY0U8LArc0wLHXQRNg1rJViDYiXFPhYGsXgbhk7YBjUGFJcDEy+ST8nRBGVeHHr1qE6KslNjtiZGLJ6roOoDh5rew8v2Uw3GvqBqpIPogblaZ6Ngnw6g4ueUh7GtGHCQaqzdamhKiZr21/yZfmllIF0oM6QdL0cGNm1OEfbRxHhN0hvOfCpJo3RaNge2IlHM3gZEpmTtpxNvzjr/jlhUF0+/eLwyI+Yq+wbHHY3sw== devnexusadmin@aks'

resource aks 'Microsoft.ContainerService/managedClusters@2022-05-02-preview' = {
  name: clusterName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    dnsPrefix: dnsPrefix
    agentPoolProfiles: [
      {
        name: 'agentpool'
        osDiskSizeGB: osDiskSizeGB
        count: agentCount
        vmSize: agentVMSize
        osType: 'Linux'
        mode: 'System'
      }
    ]
    linuxProfile: {
      adminUsername: linuxAdminUsername
      ssh: {
        publicKeys: [
          {
            keyData: sshRSAPublicKey
          }
        ]
      }
    }
    addonProfiles: {
      httpApplicationRouting: {
          enabled: true
          config: {}
    }
  }
  }
}

output controlPlaneFQDN string = aks.properties.fqdn
