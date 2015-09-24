#!powershell
# WANT_JSON
# POWERSHELL_COMMON

# Configure Powershell to use powerCLI commands
Add-PSSnapin VMware.VimAutomation.Core

# Start configuration

$vcenter = $args[0]
$vmname = $args[1]

$GuestCred = $args[2]
$GuestPass = $args[3]

#Connection to Vcenter
Connect-VIServer -User $GuestCred -Password $GuestPass -Server $vcenter

function ConnectNetAdapter {
Get-Vm -name $vmname | Get-NetworkAdapter | foreach { Set-NetworkAdapter $_ -Connected:$true -StartConnected:$true -Confirm:$false }
}

ConnectNetAdapter

Disconnect-VIServer -Server $vcenter -confirm:$false

