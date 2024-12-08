#Install the required PowerShell modules

#Connect to Azure account:
Connect-AzAccount

#import ConfigFile
."$PSScriptRoot\Configuration.ps1"

#Create a resource group
New-AzResourceGroup -Name $VirtualDesktopConfig.resourceGroupName -Location $VirtualDesktopConfig.location

#Create a virtual network:
$VNetParameters =@{
    ResourceGroupName = $VirtualDesktopConfig.resourceGroupName
    Location = $VirtualDesktopConfig.location
    
    Name = $VirtualDesktopConfig.vnetName
    AddressPrefix = “10.0.0.0/16”
}
$vnet = New-AzVirtualNetwork @VNetParameters

Add-AzVirtualNetworkSubnetConfig -Name $VirtualDesktopConfig.subnetName -AddressPrefix “10.0.0.0/24” -VirtualNetwork $VirtualDesktopConfig.vnet
$vnet | Set-AzVirtualNetwork 

#Create a virtual desktop host pool:
$HPparameters = @{
    Name = $VirtualDesktopConfig.HostPoolName
    ResourceGroupName = $VirtualDesktopConfig.ResourceGroupName
    HostPoolType = 'Pooled'
    LoadBalancerType = 'BreadthFirst'
    PreferredAppGroupType = 'Desktop'
    MaxSessionLimit = $VirtualDesktopConfig.MaxSessions
    Location = $VirtualDesktopConfig.Location
}

New-AzWvdHostPool @HPparameters

#Create a workspace:
$WSparameters = @{
    Name = $VirtualDesktopConfig.workspaceName
    ResourceGroupName = $VirtualDesktopConfig.ResourceGroupName
    Location = $VirtualDesktopConfig.location
}
 
 New-AzWvdWorkspace @WSparameters

# Get Host Pool resource ID
    $HPIDparameters = @{
    Name = $VirtualDesktopConfig.HostPoolName
    ResourceGroupName = $VirtualDesktopConfig.ResourceGroupName
    }
    $hostPoolArmPath = (Get-AzWvdHostPool @HPIDparameters).Id

# New Desktop Application Group
$AGparameters = @{
    Name = $VirtualDesktopConfig.ApplicationGroupName
    ResourceGroupName = $VirtualDesktopConfig.ResourceGroupName
    ApplicationGroupType = 'Desktop'
    HostPoolArmPath = $hostPoolArmPath
    Location = $VirtualDesktopConfig.location
}

New-AzWvdApplicationGroup @AGparameters

# Get the resource ID of the application group that you want to add to the workspace

$AGIDparameters = @{
    Name = $VirtualDesktopConfig.ApplicationGroupName
    ResourceGroupName = $VirtualDesktopConfig.ResourceGroupName
}

$appGroupPath = (Get-AzWvdApplicationGroup @AGIDparameters).Id

# Add the application group to the workspace
$AGWSparameters = @{
    Name = $VirtualDesktopConfig.workspaceName
    ResourceGroupName = $VirtualDesktopConfig.ResourceGroupName
    ApplicationGroupReference = $appGroupPath
}

Update-AzWvdWorkspace @AGWSparameters

# Get the object ID of the user group that you want to assign to the application group
$userGroupId = (Get-AzADGroup -DisplayName $VirtualDesktopConfig.UserGroupName).Id

# Assign users to the application group
$Userparameters = @{
    ObjectId = $userGroupId
    Name = $VirtualDesktopConfig.ApplicationGroupName
    ResourceGroupName = $VirtualDesktopConfig.ResourceGroupName
    RoleDefinitionName = 'Desktop Virtualization User'
    ResourceType = 'Microsoft.DesktopVirtualization/applicationGroups'
}

New-AzRoleAssignment @Userparameters

Write-Verbose "Add FSLogix containers for user profiles with Azure Files and Entra ID" 

