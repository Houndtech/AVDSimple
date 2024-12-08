<# Help paragraph#>

$VirtualDesktopConfig = @{
    Subscription="mysub";                                   #Azure subscription to be used for the virtual desktops
    resourceGroupName = “YourResourceGroupName”;            #Suggest using a unique Resource Group for individual pools or groups of pools
    location = “YourLocation”;                              #Azure resource region - must match Azure names. For example: "East US" = "eastus", "South Central US"= "southcentralus"
    vnetName = “YourVNetName”;                              #Name of virtual network - must be globally unique 
    subnetName = “YourSubnetName”;                          #Self-explanitory
    hostPoolName = “YourHostPoolName”                       #Self-explanitory             
    vmNamePrefix = “YourVMNamePrefix”                       #Prefix for sessionhosts 
    vmSize = “Standard_D4ds_v4”                             #Standard Azure VM sizes
    imageOffer = “Windows-11”
    imagePublisher = “MicrosoftWindowsDesktop”
    imageSku = “win11-23h2-avd-m365”
    workspaceName = “YourWorkspaceName”
    MaxSessions = "MaxSessionsLimit"
    ApplicationGroupName = "YourApplicationGroupName"
    UserGroupName = "YourUserGroup"
}
    
    
    
