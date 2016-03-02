# Name of subscription 
# $SubscriptionName = "Copy the SubscriptionName property you get from Get-AzureSubscription"
$SubscriptionName = "NOMEDELLASOTTOSCRIZIONE"

# Name of storage account (where VMs will be deployed)
# $StorageAccount = "Copy the Label property you get from Get-AzureStorageAccount"
$StorageAccount = "NOMESTORAGEACCOUNT"
 

function Provision-VM( [string]$VmName ) {

    Start-Job -ArgumentList $VmName {

        param($VmName)
        #$Location = "Copy the Location property you get from Get-AzureStorageAccount"
        $Location = "West Europe"
        $InstanceSize = "Standard_D1"      # You can use any other instance, such as Large, A6, and so on
        $AdminUsername = "USER"          # Write the name of the administrator account in the new VM
        $Password = "PASSWORD"             # Write the password of the administrator account in the new VM
        $Image = "NOMEIMMAGINESALVATA"
        
        # You can list your own images using the following command:
        # Get-AzureVMImage | Where-Object {$_.PublisherName -eq "User" }

        New-AzureVMConfig -Name $VmName -ImageName $Image -InstanceSize $InstanceSize |
        Add-AzureProvisioningConfig -Windows -Password $Password -AdminUsername $AdminUsername|
        New-AzureVM -Location $Location -ServiceName "$VmName" -Verbose
    }
}

# Set the proper storage - you might remove this line if you have only one storage in the subscription
Set-AzureSubscription -SubscriptionName $SubscriptionName -CurrentStorageAccount $StorageAccount

# Select the subscription - this line is fundamental if you have access to multiple subscription
# You might remove this line if you have only one subscription
Select-AzureSubscription -SubscriptionName $SubscriptionName

# Every line in the following list provisions one VM using the name specified in the argument
# You can change the number of lines - use a unique name for every VM - don't reuse names
# already used in other VMs already deployed

Provision-VM "VM01"
Provision-VM "VM02"

# Wait for all to complete

While (Get-Job -State "Running") { 
    Get-Job -State "Completed" | Receive-Job
    Start-Sleep 1 
}

# Display output from all jobs
Get-Job | Receive-Job

# Cleanup of jobs
Remove-Job *

# Displays batch completed
echo "Provisioning VM Completed"