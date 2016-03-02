### rimedio il profilo del mio account Azure la prima volta (mi loggo e lancio)
### per loggarsi lancio il primo comando, apre una http e mi loggo con user e pwd, poi esporto certificato
Add-AzureAccount 
Get-AzurePublishSettingsFile


### pulisco profilo azure e testo se la pulizia ha funzionato
Clear-AzureProfile -Force 
Get-Azuresubscription
Write-Output "### pulizia profilo Azure effettuata"
pause 

### importo il profilo azure precedentemente scaricato e testo se ha funzionato
Import-AzurePublishSettingsFile 'C:\Users\xxxxx\Windows Azure MSDN xxxxxcredentials.publishsettings'
Get-Azuresubscription
Write-Output "### Profilo importato"
pause

Select-AzureSubscription "SUBSCRIPTIONNAME"

### assegno i valori della VM azure alla variabile
$VM =  Get-AzureVM
Write-Output $vm
pause

### partenza VM
Start-AzureVM -ServiceName $VM.ServiceName -Name $VM.Name
Write-Output "### aspetta 5 minuti e vai avanti, ti verrà scaricato il file per la connessione"
pause

###  get rdp per connessione (solo dopo che è partita (test sullo stato??)
Get-AzureRemoteDesktopFile -ServiceName $VM.ServiceName -Name $VM.Name -Launch

### spegnimento VM
Stop-AzureVM -ServiceName $VM.ServiceName -Name $VM.Name -Force

### VERIFICA STATO VM 
### assegno i valori della VM azure alla variabile
$VM =  Get-AzureVM
# Write-Output $vm
$VM | Select-Object Name, Status, PowerState
